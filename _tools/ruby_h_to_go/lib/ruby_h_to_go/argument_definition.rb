# frozen_string_literal: true

module RubyHToGo
  # Proxy class for generating argument in go function
  class ArgumentDefinition
    extend Forwardable

    def_delegators :@definition, :==, :type, :type=, :name, :name=, :pointer, :pointer=, :pointer?, :length, :length=

    include Helper

    # @param definition [RubyHeaderParser::ArgumentDefinition]
    def initialize(definition)
      @definition = definition
    end

    # These are reserved in Go
    C_NAME_TO_GO_NAME = {
      "var"   => "v",
      "func"  => "fun",
      "range" => "r",
      "type"  => "r",
    }.freeze

    # @return [String] Variable name available in Go
    def go_name
      return C_NAME_TO_GO_NAME[name] if C_NAME_TO_GO_NAME[name]

      name
    end

    # @return [String]
    def go_function_arg
      "#{go_name} #{ruby_c_type_to_go_type(type, pointer:, type: :arg)}"
    end

    # @return [String]
    def cast_to_cgo
      return "toCArray[#{ruby_c_type_to_go_type(type)}, #{cast_to_cgo_type(type)}](#{go_name})" if pointer == :array

      "#{cast_to_cgo_type(type)}(#{go_name})"
    end
  end
end
