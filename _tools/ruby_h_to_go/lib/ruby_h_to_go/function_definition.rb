# frozen_string_literal: true

module RubyHToGo
  # Proxy class for generating go function
  class FunctionDefinition
    # @!attribute [r] header_dir
    #   @return [String]
    attr_reader :header_dir

    extend Forwardable

    def_delegators :@definition, :==, :name, :name=, :definition, :definition=, :filepath, :filepath=

    include GeneratorHelper

    # @param definition [RubyHeaderParser::FunctionDefinition]
    def initialize(definition:, header_dir:)
      @definition = definition
      @header_dir = header_dir
    end

    # @return [RubyHToGo::TyperefDefinition]
    def typeref
      @typeref ||= RubyHToGo::TyperefDefinition.new(definition: @definition.typeref, header_dir:)
    end

    # @return [Array<RubyHToGo::ArgumentDefinition>]
    def args
      @args ||= @definition.args.map { |arg| RubyHToGo::ArgumentDefinition.new(definition: arg, header_dir:) }
    end

    # Write definition as go file
    # @param [String] dist_dir
    def write_go_file(dist_dir)
      go_file_path = File.join(dist_dir, generate_go_file_name(header_dir:, ruby_header_file: filepath))

      generate_initial_go_file(go_file_path)

      File.open(go_file_path, "a") do |f|
        f.write(generate_go_content)
      end
    end

    # @return [String]
    def generate_go_content
      go_function_name = snake_to_camel(name)
      go_function_args = args.map(&:go_function_arg)

      go_function_typeref = typeref.go_function_typeref

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
      char_var_count = args.count { |c_arg| c_arg.type == "char" && c_arg.pointer == :ref }

      before_call_function_lines = []
      after_call_function_lines = []

      args.each do |c_arg|
        if c_arg.type == "char" && c_arg.pointer == :ref
          if char_var_count >= 2
            char_var_name = "char#{snake_to_camel(c_arg.go_name)}"
            clean_var_name = "cleanChar#{c_arg.go_name}"
          else
            char_var_name = "char"
            clean_var_name = "clean"
          end

          go_function_lines << "#{char_var_name}, #{clean_var_name} := string2Char(#{c_arg.go_name})"
          go_function_lines << "defer #{clean_var_name}()"
          go_function_lines << ""

          casted_go_args << char_var_name.to_s
        elsif c_arg.pointer == :ref
          if c_arg.type == "void"
            casted_go_args << "toCPointer(#{c_arg.go_name})"
          else
            c_var_name = "c#{snake_to_camel(c_arg.go_name)}"

            before_call_function_lines << "var #{c_var_name} #{cast_to_cgo_type(c_arg.type)}"
            after_call_function_lines <<
              "*#{c_arg.go_name} = #{ruby_c_type_to_go_type(c_arg.type, type: :arg)}(#{c_var_name})"

            casted_go_args << "&#{c_var_name}"
          end
        else
          casted_go_args << c_arg.cast_to_cgo
        end
      end

      call_c_method << casted_go_args.join(", ")
      call_c_method << ")"

      go_function_lines.push(*before_call_function_lines)
      if go_function_typeref == ""
        go_function_lines << call_c_method
        go_function_lines.push(*after_call_function_lines)
      else
        go_function_lines << "ret := #{go_function_typeref}(#{call_c_method})"
        go_function_lines.push(*after_call_function_lines)
        go_function_lines << "return ret"
      end

      go_function_lines << "}"
      go_function_lines << ""
      go_function_lines << ""

      go_function_lines.join("\n")
    end
  end
end
