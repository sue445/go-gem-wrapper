# frozen_string_literal: true

module RubyHeaderParser
  # struct definition in header file
  class StructDefinition
    # @!attribute name
    #   @return [String]
    attr_accessor :name

    # @param name [String]
    def initialize(name:)
      @name = name
    end

    # @param other [StructDefinition]
    # @return [Boolean]
    def ==(other)
      other.is_a?(StructDefinition) && name == other.name
    end
  end
end
