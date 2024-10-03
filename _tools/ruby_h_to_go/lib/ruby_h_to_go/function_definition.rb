# frozen_string_literal: true

module RubyHToGo
  # Proxy class for generating go function
  class FunctionDefinition
    extend Forwardable

    def_delegators :@definition, :==, :name, :name=, :definition, :definition=

    include GeneratorHelper

    # @param definition [RubyHeaderParser::FunctionDefinition]
    def initialize(definition:)
      @definition = definition
    end

    # @return [RubyHToGo::TyperefDefinition]
    def typeref
      @typeref ||= RubyHToGo::TyperefDefinition.new(definition: @definition.typeref)
    end

    # @return [Array<RubyHToGo::ArgumentDefinition>]
    def args
      @args ||= @definition.args.map { |arg| RubyHToGo::ArgumentDefinition.new(definition: arg) }
    end

    # Write definition as go file
    # @param [String] dist_dir
    def write_go_file(dist_dir)
      go_file_path = File.join(dist_dir, "function_generated.go")

      generate_initial_go_file(go_file_path)

      File.open(go_file_path, "a") do |f|
        f.write(generate_go_content)
      end
    end

    # @return [String]
    def generate_go_content
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

      casted_go_args = []
      char_var_count = args.count { |c_arg| c_arg.type == "char" && c_arg.pointer == :ref }
      chars_var_count = args.count { |c_arg| c_arg.type == "char" && c_arg.pointer == :str_array }

      before_call_function_lines = []
      after_call_function_lines = []

      args.each do |c_arg|
        casted_go_arg, before_lines, after_lines = c_arg.generate_go_arguments(char_var_count:, chars_var_count:)

        casted_go_args << casted_go_arg
        before_call_function_lines.push(*before_lines)
        after_call_function_lines.push(*after_lines)
      end

      call_c_method = "C.#{name}(#{casted_go_args.join(", ")})"

      go_function_lines.push(*before_call_function_lines)
      cast_func = typeref.cast_func_for_function_return
      if cast_func == ""
        go_function_lines << call_c_method
        go_function_lines.push(*after_call_function_lines)
      elsif after_call_function_lines.empty?
        go_function_lines << "return #{cast_func}(#{call_c_method})"
      else
        go_function_lines << "ret := #{cast_func}(#{call_c_method})"
        go_function_lines.push(*after_call_function_lines)
        go_function_lines << "return ret"
      end

      go_function_lines << "}"
      go_function_lines << ""
      go_function_lines << ""

      go_function_lines.join("\n")
    end

    # @return [String]
    def go_function_name
      return name if name.match?(/^[A-Z0-9_]+$/)

      snake_to_camel(name)
    end
  end
end
