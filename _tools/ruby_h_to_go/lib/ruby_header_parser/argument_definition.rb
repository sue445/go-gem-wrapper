# frozen_string_literal: true
module RubyHeaderParser
  # argument definition for {RubyHeaderParser::FunctionDefinition}
  class ArgumentDefinition
    # @!attribute type
    #   @return [String]
    attr_accessor :type

    # @!attribute name
    #   @return [String]
    attr_accessor :name

    # @!attribute pointer
    #   @return [Symbol,nil]
    attr_accessor :pointer

    # @param type [String]
    # @param name [String]
    # @param pointer [Symbol,nil] :ref
    def initialize(type:, name:, pointer: nil)
      @type = type
      @name = name
      @pointer = pointer
    end

    # @param other [ArgumentDefinition]
    # @return [Boolean]
    def ==(other)
      other.is_a?(ArgumentDefinition) && type == other.type && name == other.name && pointer == other.pointer
    end

    # @return [Boolean]
    def pointer?
      !!pointer
    end
  end
end
