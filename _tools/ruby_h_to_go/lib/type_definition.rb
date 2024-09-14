class TypeDefinition
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

  # @param other [TypeDefinition]
  # @return [Boolean]
  def ==(other)
    other.is_a?(TypeDefinition) && name == other.name && filepath == other.filepath
  end
end
