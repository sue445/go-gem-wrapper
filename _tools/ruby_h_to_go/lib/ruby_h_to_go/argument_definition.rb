module RubyHToGo
  class ArgumentDefinition
    extend Forwardable

    def_delegators :@definition, :==, :type, :type=, :name, :name=, :pointer, :pointer=, :pointer?

    # @param definition [RubyHeaderParser::ArgumentDefinition]
    def initialize(definition)
      @definition = definition
    end
  end
end
