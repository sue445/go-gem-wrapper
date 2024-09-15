module RubyHToGo
  class FunctionDefinition
    extend Forwardable

    def_delegators :@definition, :==, :name, :name=, :definition, :definition=, :filepath, :filepath=

    include Helper

    # @param definition [RubyHeaderParser::FunctionDefinition]
    def initialize(definition)
      @definition = definition
    end

    # @return [RubyHToGo::TyperefDefinition]
    def typeref
      @typeref ||= RubyHToGo::TyperefDefinition.new(@definition.typeref)
    end

    # @return [Array<RubyHToGo::ArgumentDefinition>]
    def args
      @args ||= @definition.args.map { |arg| RubyHToGo::ArgumentDefinition.new(arg) }
    end

    # Write definition as go file
    # @param [String] dist_dir
    # @param [String] header_dir
    def write_go_file(dist_dir:, header_dir:)
      go_file_path = File.join(dist_dir, go_file_name(header_dir:, ruby_header_file: filepath))

      generate_initial_go_file(go_file_path)

      File.open(go_file_path, "a") do |f|
        f.write(generate_go_content)
      end
    end

    # @return [String]
    def generate_go_content
      args.each do |c_arg|
        case c_arg.name
        when "var"
          # `var` is reserved in Go
          c_arg.name = "v"
        when "func"
          # `func` is reserved in Go
          c_arg.name = "fun"
        when "range"
          # `range` is reserved in Go
          c_arg.name = "r"
        when "type"
          # `type` is reserved in Go
          c_arg.name = "t"
        end
      end

      go_function_name = snake_to_camel(name)
      go_function_args = args.map do |c_arg|
        "#{c_arg.name} #{ruby_c_type_to_go_type(c_arg.type, pointer: c_arg.pointer, type: :arg)}"
      end

      go_function_typeref =
        if typeref.type == "void" && !typeref.pointer?
          ""
        else
          ruby_c_type_to_go_type(typeref.type, type: :return, pointer: typeref.pointer)
        end

      go_function_lines = [
        "// #{go_function_name} calls `#{name}` in C",
        "//",
        "// Original definition is following",
        "//",
        "//\t#{definition}",
      ]

      go_function_lines << "func #{go_function_name}(#{go_function_args.join(", ")}) #{go_function_typeref} {"

      call_c_method = "C.#{name}("

      casted_go_args = []
      char_var_count = args.count { |c_arg| c_arg.type == "char" && c_arg.pointer }

      before_call_function_lines = []
      after_call_function_lines = []

      args.each do |c_arg|
        if c_arg.type == "char" && c_arg.pointer?
          if char_var_count >= 2
            char_var_name = "char#{snake_to_camel(c_arg.name)}"
            clean_var_name = "cleanChar#{(c_arg.name)}"
          else
            char_var_name = "char"
            clean_var_name = "clean"
          end

          go_function_lines << "#{char_var_name}, #{clean_var_name} := string2Char(#{c_arg.name})"
          go_function_lines << "defer #{clean_var_name}()"
          go_function_lines << ""

          casted_go_args << "#{char_var_name}"
        else
          if c_arg.pointer == :ref
            if c_arg.type == "void"
              casted_go_args << "toCPointer(#{c_arg.name})"
            else
              c_var_name = "c#{snake_to_camel(c_arg.name)}"

              before_call_function_lines << "var #{c_var_name} C.#{c_arg.type}"
              after_call_function_lines << "*#{c_arg.name} = #{ruby_c_type_to_go_type(c_arg.type, type: :arg)}(#{c_var_name})"
              casted_go_args << "&#{c_var_name}"
            end
          else
            casted_go_args << "#{cast_to_cgo_type(c_arg.type)}(#{c_arg.name})"
          end
        end
      end

      call_c_method << casted_go_args.join(", ")
      call_c_method << ")"

      if go_function_typeref == ""
        go_function_lines.push(*before_call_function_lines)
        go_function_lines << call_c_method
        go_function_lines.push(*after_call_function_lines)
      else
        go_function_lines.push(*before_call_function_lines)
        go_function_lines << "ret := #{go_function_typeref}(#{call_c_method})"
        go_function_lines.push(*after_call_function_lines)
        go_function_lines << "return ret"
      end

      go_function_lines << "}"
      go_function_lines << ""
      go_function_lines << ""

      go_function_lines.join("\n")
    end

    private

    # Cast C type to cgo type. (Used in wrapper function)
    # @param typename [String]
    # @return [String]
    def cast_to_cgo_type(typename)
      case typename
      when "unsigned long"
        return "C.ulong"
      when "unsigned int"
        return "C.uint"
      when "unsigned char"
        return "C.uchar"
      when "VALUE*"
        return "toCValueArray"
      when /^VALUE\s*\(\*func\)\s*\(ANYARGS\)$/
        return "toCPointer"
      end

      "C.#{typename}"
    end

    # Convert C type to Go type. (used in wrapper function args and return type etc)
    # @param typename [String]
    # @param type [Symbol,nil] :arg, :return
    # @param pointer [Symbol,nil] Whether pointer hint
    # @return [String]
    def ruby_c_type_to_go_type(typename, type: nil, pointer: nil)
      typename = typename.delete_prefix("struct ").delete_prefix("volatile ")

      if pointer
        case typename
        when "char", "const char"
          case type
          when :arg, :return
            return "string"
          else
            return "char2String"
          end
        when "void"
          return "unsafe.Pointer"
        end

        go_type_name = ruby_c_type_to_go_type(typename, type: type, pointer: nil)

        return "[]#{go_type_name}" if pointer == :array

        return "*#{go_type_name}"
      end

      case typename
      when "unsigned int", "unsigned long"
        return "uint"
      when "unsigned char"
        return "Uchar"
      when /^VALUE\s*\(\*func\)\s*\(ANYARGS\)$/
        return "unsafe.Pointer"
      when /^[A-Z]+$/, "int"
        # e.g. VALUE
        return typename
      when "void"
        return "unsafe.Pointer" if pointer == :ref && type == :return
      end

      snake_to_camel(typename)
    end
  end
end
