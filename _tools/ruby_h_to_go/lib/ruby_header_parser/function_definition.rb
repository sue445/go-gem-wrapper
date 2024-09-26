# frozen_string_literal: true

module RubyHeaderParser
  # function definition in header file
  class FunctionDefinition
    # @!attribute name
    #   @return [String]
    attr_accessor :name

    # @!attribute definition
    #   @return [String]
    attr_accessor :definition

    # @!attribute typeref
    #   @return [TyperefDefinition]
    attr_accessor :typeref

    # @!attribute args
    #   @return [Array<ArgumentDefinition>]
    attr_accessor :args

    # @param name [String]
    # @param definition [String]
    # @param typeref [TyperefDefinition]
    # @param args [Array<ArgumentDefinition>]
    def initialize(name:, definition:, typeref:, args:)
      @name = name
      @definition = definition
      @typeref = typeref
      @args = args
    end

    # @param other [FunctionDefinition]
    # @return [Boolean]
    def ==(other)
      other.is_a?(FunctionDefinition) && name == other.name && definition == other.definition &&
        typeref == other.typeref && args == other.args
    end
  end
end
