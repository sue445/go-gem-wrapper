# frozen_string_literal: true

module RubyHeaderParser
  # Manager for `data.yml`
  class Data
    # @!attribute [r] data
    #   @return [Hash]
    attr_reader :data

    def initialize
      @data = YAML.load_file(File.join(__dir__, "data.yml"))
    end

    # @param function_name [String]
    # @param index [Integer] arg position (0 origin)
    # @return [Symbol] :ref, :array
    def function_arg_pointer_hint(function_name:, index:)
      pointer_hint = data["function"]["pointer_hint"].dig(function_name, index)
      return pointer_hint.to_sym if pointer_hint

      :ref
    end
  end
end
