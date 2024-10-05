# frozen_string_literal: true

module RubyHToGo
  # Proxy class for generating argument in go function
  class ArgumentDefinition
    extend Forwardable

    def_delegators :@definition, :==, :type, :type=, :name, :name=, :pointer, :pointer=, :pointer?, :length, :length=

    # @param definition [RubyHeaderParser::ArgumentDefinition]
    # @param header_dir [String]
    def initialize(definition:)
      @definition = definition
    end

    C_NAME_TO_GO_NAME = {
      # These are reserved in Go
      "var"   => "v",
      "func"  => "fun",
      "range" => "r",
      "type"  => "t",

      # Can't use "_" as a value
      "_"     => "arg",
    }.freeze

    # @return [String] Variable name available in Go
    def go_name
      return C_NAME_TO_GO_NAME[name] if C_NAME_TO_GO_NAME[name]

      name
    end

    # @return [String]
    def go_function_arg
      "#{go_name} #{GoUtil.ruby_c_type_to_go_type(type, pointer:, pointer_length: length, pos: :arg)}"
    end

    # @return [String]
    def cast_to_cgo
      case pointer
      when :array
        return "toCArray[#{GoUtil.ruby_c_type_to_go_type(type)}, #{GoUtil.cast_to_cgo_type(type)}](#{go_name})"
      when :ref_array
        return "toCArray[*#{GoUtil.ruby_c_type_to_go_type(type)}, *#{GoUtil.cast_to_cgo_type(type)}](#{go_name})"
      when :sref
        return go_name if type == "void" && length == 2

        return "(#{"*" * length}#{GoUtil.cast_to_cgo_type(type)})(unsafe.Pointer(#{go_name}))"
      when :in_ref
        return "(*#{GoUtil.cast_to_cgo_type(type)})(#{go_name})"
      end

      "#{GoUtil.cast_to_cgo_type(type)}(#{go_name})"
    end

    # @param char_var_count [Integer]
    # @param chars_var_count [Integer]
    #
    # @return [Array<String, Array<String>, Array<String>>]
    #   - casted_go_arg [String]
    #   - before_call_function_lines [Array<String>]
    #   - after_call_function_lines [Array<String>]
    def generate_go_arguments(char_var_count:, chars_var_count:)
      case pointer
      when :ref
        case type
        when "char"
          generate_go_arguments_for_char_pointer(char_var_count)

        when "void"
          # c_arg is pointer
          [go_name, [], []]

        else
          c_var_name = "c#{GoUtil.snake_to_camel(go_name)}"

          before_call_function_line = "var #{c_var_name} #{GoUtil.cast_to_cgo_type(type)}"
          after_call_function_line = "*#{go_name} = #{GoUtil.ruby_c_type_to_go_type(type, pos: :arg)}(#{c_var_name})"

          ["&#{c_var_name}", [before_call_function_line], [after_call_function_line]]
        end

      when :function
        ["toCFunctionPointer(#{go_name})", [], []]

      when :str_array
        generate_go_arguments_for_str_array(chars_var_count)

      else
        [cast_to_cgo, [], []]
      end
    end

    private

    # @param char_var_count [Integer]
    #
    # @return [Array<String, Array<String>, Array<String>>]
    #   - casted_go_arg [String]
    #   - before_call_function_lines [Array<String>]
    #   - after_call_function_lines [Array<String>]
    def generate_go_arguments_for_char_pointer(char_var_count)
      # self is string
      if char_var_count >= 2
        chars_var_name = "char#{GoUtil.snake_to_camel(go_name)}"
        clean_var_name = "cleanChar#{go_name}"
      else
        chars_var_name = "char"
        clean_var_name = "clean"
      end

      before_call_function_lines = [
        "#{chars_var_name}, #{clean_var_name} := string2Char(#{go_name})",
        "defer #{clean_var_name}()",
        "",
      ]

      [chars_var_name, before_call_function_lines, []]
    end

    # @param chars_var_count [Integer]
    #
    # @return [Array<String, Array<String>, Array<String>>]
    #   - casted_go_arg [String]
    #   - before_call_function_lines [Array<String>]
    #   - after_call_function_lines [Array<String>]
    def generate_go_arguments_for_str_array(chars_var_count)
      if chars_var_count >= 2
        chars_var_name = "chars#{GoUtil.snake_to_camel(go_name)}"
        clean_var_name = "cleanChars#{go_name}"
      else
        chars_var_name = "chars"
        clean_var_name = "cleanChars"
      end

      before_call_function_lines = [
        "#{chars_var_name}, #{clean_var_name} := strings2Chars(#{go_name})",
        "defer #{clean_var_name}()",
        "",
      ]

      [chars_var_name, before_call_function_lines, []]
    end
  end
end
