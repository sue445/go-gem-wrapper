module RubyHeaderParser
  class FunctionDefinition
    # @!attribute name
    #   @return [String]
    attr_accessor :name

    # @!attribute definition
    #   @return [String]
    attr_accessor :definition

    # @!attribute filepath
    #   @return [String]
    attr_accessor :filepath

    # @!attribute typeref
    #   @return [TyperefDefinition]
    attr_accessor :typeref

    # @!attribute args
    #   @return [Array<ArgumentDefinition>]
    attr_accessor :args

    # @param name [String]
    # @param definition [String]
    # @param filepath [String]
    # @param typeref [TyperefDefinition]
    # @param args [Array<ArgumentDefinition>]
    def initialize(name:, definition:, filepath:, typeref:, args:)
      @name = name
      @definition = definition
      @filepath = filepath
      @typeref = typeref
      @args = args
    end

    # @param other [FunctionDefinition]
    # @return [Boolean]
    def ==(other)
      other.is_a?(FunctionDefinition) && name == other.name && definition == other.definition &&
        filepath == other.filepath && typeref == other.typeref && args == other.args
    end
  end
end
