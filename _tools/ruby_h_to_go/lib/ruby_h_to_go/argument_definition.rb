# frozen_string_literal: true
module RubyHToGo
  # Proxy class for generating argument in go function
  class ArgumentDefinition
    extend Forwardable

    def_delegators :@definition, :==, :type, :type=, :name, :name=, :pointer, :pointer=, :pointer?

    include Helper

    # @param definition [RubyHeaderParser::ArgumentDefinition]
    def initialize(definition)
      @definition = definition
    end

    # @return [String] Variable name available in Go
    def go_name
      case name
      when "var"
        # `var` is reserved in Go
        return "v"
      when "func"
        # `func` is reserved in Go
        return "fun"
      when "range"
        # `range` is reserved in Go
        return "r"
      when "type"
        # `type` is reserved in Go
        return "t"
      end

      name
    end

    # @return [String]
    def go_function_arg
      "#{go_name} #{ruby_c_type_to_go_type(type, pointer:, type: :arg)}"
    end
  end
end
