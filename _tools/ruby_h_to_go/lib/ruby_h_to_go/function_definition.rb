module RubyHToGo
  class FunctionDefinition
    extend Forwardable

    def_delegators :@definition, :==, :name, :name=, :definition, :definition=, :filepath, :filepath=

    # @param definition [RubyHeaderParser::FunctionDefinition]
    def initialize(definition)
      @definition = definition
    end

    # @return [RubyHToGo::TyperefDefinition]
    def typeref
      @typeref ||= RubyHToGo::TyperefDefinition.new(@definition.typeref)
    end

    # @return [Array<RubyHToGo::ArgumentDefinition>]
    def args
      @args ||= @definition.args.map { |arg| RubyHToGo::ArgumentDefinition.new(arg) }
    end
  end
end
