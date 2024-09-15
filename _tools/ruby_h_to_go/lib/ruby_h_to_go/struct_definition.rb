module RubyHToGo
  class StructDefinition
    extend Forwardable

    def_delegators :@definition, :==, :name, :name=, :filepath, :filepath=

    # @param definition [RubyHeaderParser::StructDefinition]
    def initialize(definition)
      @definition = definition
    end
  end
end
