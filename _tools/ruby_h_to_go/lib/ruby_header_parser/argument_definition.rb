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
    #   @return [Symbol,nil] :ref, :array
    attr_accessor :pointer

    # @!attribute length
    #   @return [Integer]
    attr_accessor :length

    # @param type [String]
    # @param name [String]
    # @param pointer [Symbol,nil] :ref, :array
    # @param length [String]
    def initialize(type:, name:, pointer: nil, length: 0)
      @type = type
      @name = name
      @pointer = pointer
      @length = length
    end

    # @param other [ArgumentDefinition]
    # @return [Boolean]
    def ==(other)
      other.is_a?(ArgumentDefinition) && type == other.type && name == other.name && pointer == other.pointer &&
        length == other.length
    end

    # @return [Boolean]
    def pointer?
      !!pointer
    end
  end
end
