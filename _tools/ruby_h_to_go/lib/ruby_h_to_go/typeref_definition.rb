module RubyHToGo
  class TyperefDefinition
    extend Forwardable

    def_delegators :@definition, :==, :type, :type=, :pointer, :pointer=, :pointer?

    # @param definition [RubyHeaderParser::TyperefDefinition]
    def initialize(definition)
      @definition = definition
    end
  end
end
