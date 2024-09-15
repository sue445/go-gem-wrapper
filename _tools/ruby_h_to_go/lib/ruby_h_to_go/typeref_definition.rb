module RubyHToGo
  class TyperefDefinition
    extend Forwardable

    def_delegators :@definition, :==, :type, :type=, :pointer, :pointer=, :pointer?

    include Helper

    # @param definition [RubyHeaderParser::TyperefDefinition]
    def initialize(definition)
      @definition = definition
    end
  end
end
