module RubyHToGo
  class TypeDefinition
    extend Forwardable

    def_delegators :@definition, :==, :name, :name=, :filepath, :filepath=

    # @param definition [RubyHeaderParser::TypeDefinition]
    def initialize(definition)
      @definition = definition
    end
  end
end
