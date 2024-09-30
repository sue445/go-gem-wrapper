# frozen_string_literal: true

module RubyHToGo
  # Proxy class for generating typeref in go function
  class TyperefDefinition
    extend Forwardable

    def_delegators :@definition, :==, :type, :type=, :pointer, :pointer=, :pointer?

    include GeneratorHelper

    # @param definition [RubyHeaderParser::TyperefDefinition]
    def initialize(definition:)
      @definition = definition
    end

    # @return [String]
    def go_function_typeref
      return "" if type == "void" && !pointer?

      ruby_c_type_to_go_type(type, pos: :typeref, pointer:)
    end

    # @return [String]
    def cast_func_for_function_return
      return "" if type == "void" && !pointer?

      cast_func = ruby_c_type_to_go_type(type, pos: :return, pointer:)
      return "(#{cast_func})" if cast_func.start_with?("*")

      cast_func
    end
  end
end
