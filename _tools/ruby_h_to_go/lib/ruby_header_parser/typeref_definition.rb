# frozen_string_literal: true

module RubyHeaderParser
  # typeref definition for {RubyHeaderParser::FunctionDefinition}
  class TyperefDefinition
    # @!attribute type
    #   @return [String]
    attr_accessor :type

    # @!attribute pointer
    #   @return [Symbol,nil]
    attr_accessor :pointer

    # @param type [String]
    # @param pointer [Symbol,nil] :ref
    def initialize(type:, pointer: nil)
      @type = type
      @pointer = pointer
    end

    # @return [Boolean]
    def pointer?
      !!pointer
    end

    # @param other [TyperefDefinition]
    # @return [Boolean]
    def ==(other)
      other.is_a?(TyperefDefinition) && type == other.type && pointer == other.pointer
    end
  end
end
