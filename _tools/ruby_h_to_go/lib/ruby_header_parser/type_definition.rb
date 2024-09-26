# frozen_string_literal: true

module RubyHeaderParser
  # type definition in header file
  class TypeDefinition
    # @!attribute name
    #   @return [String]
    attr_accessor :name

    # @param name [String]
    def initialize(name:)
      @name = name
    end

    # @param other [TypeDefinition]
    # @return [Boolean]
    def ==(other)
      other.is_a?(TypeDefinition) && name == other.name
    end
  end
end
