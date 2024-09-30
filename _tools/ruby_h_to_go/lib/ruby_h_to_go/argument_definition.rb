# frozen_string_literal: true

module RubyHToGo
  # Proxy class for generating argument in go function
  class ArgumentDefinition
    extend Forwardable

    def_delegators :@definition, :==, :type, :type=, :name, :name=, :pointer, :pointer=, :pointer?, :length, :length=

    include GeneratorHelper

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
      "type"  => "r",

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
      "#{go_name} #{ruby_c_type_to_go_type(type, pointer:, pointer_length: length, pos: :arg)}"
    end

    # @return [String]
    def cast_to_cgo
      case pointer
      when :array
        return "toCArray[#{ruby_c_type_to_go_type(type)}, #{cast_to_cgo_type(type)}](#{go_name})"
      when :ref_array
        return "toCArray[*#{ruby_c_type_to_go_type(type)}, *#{cast_to_cgo_type(type)}](#{go_name})"
      when :sref
        return "(#{"*" * length}#{cast_to_cgo_type(type)})(unsafe.Pointer(#{go_name}))"
      end

      "#{cast_to_cgo_type(type)}(#{go_name})"
    end
  end
end
