# frozen_string_literal: true

module RubyHeaderParser
  # enum definition in header file
  class EnumDefinition
    # @!attribute name
    #   @return [String]
    attr_accessor :name

    # @!attribute enum_value_definitions
    #   @return [Array<String>]
    attr_accessor :values

    # @param name [String]
    # @param values [Array<String>]
    def initialize(name:, values: [])
      @name = name
      @values = values
    end

    # @param other [EnumDefinition]
    # @return [Boolean]
    def ==(other)
      other.is_a?(EnumDefinition) && name == other.name && values == other.values
    end
  end
end
