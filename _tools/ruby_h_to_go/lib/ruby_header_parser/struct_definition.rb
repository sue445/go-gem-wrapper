module RubyHeaderParser
  # struct definition in header file
  class StructDefinition
    # @!attribute name
    #   @return [String]
    attr_accessor :name

    # @!attribute filepath
    #   @return [String]
    attr_accessor :filepath

    # @param name [String]
    # @param filepath [String]
    def initialize(name:, filepath:)
      @name = name
      @filepath = filepath
    end

    # @param other [StructDefinition]
    # @return [Boolean]
    def ==(other)
      other.is_a?(StructDefinition) && name == other.name && filepath == other.filepath
    end
  end
end
