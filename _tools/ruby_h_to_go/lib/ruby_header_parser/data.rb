# frozen_string_literal: true

module RubyHeaderParser
  # Manager for `data.yml`
  class Data
    # @!attribute [r] data
    #   @return [Hash]
    attr_reader :data

    def initialize
      yaml = File.read(File.join(__dir__, "data.yml"))
      @data = YAML.safe_load(yaml, aliases: true, permitted_classes: [Regexp])
    end

    # @param function_name [String]
    # @param index [Integer] arg position (0 origin)
    # @return [Symbol] :ref, :array
    def function_arg_pointer_hint(function_name:, index:)
      pointer_hint = data["function"]["pointer_hint"].dig(function_name, index)
      return pointer_hint.to_sym if pointer_hint

      :ref
    end

    # rubocop:disable Style/CaseEquality

    # Whether generate C function to go
    # @param function_name [String]
    # @param filepath [String]
    # @return [Boolean]
    def should_generate_function?(function_name:, filepath:)
      return false if data["function"]["exclude_name"].any? { |format| format === function_name }
      return false if data["function"]["exclude_file"].any? { |format| format === filepath }

      data["function"]["include_name"].any? { |format| format === function_name }
    end

    # Whether generate C struct to go
    # @param struct_name [String]
    # @param filepath [String]
    # @return [Boolean]
    def should_generate_struct?(struct_name:, filepath:)
      return false if data["struct"]["exclude_name"].any? { |format| format === struct_name }
      return false if data["struct"]["exclude_file"].any? { |format| format === filepath }

      data["struct"]["include_name"].any? { |format| format === struct_name }
    end

    # Whether generate C type to go
    # @param type_name [String]
    # @param filepath [String]
    # @return [Boolean]
    def should_generate_type?(type_name:, filepath:)
      return false if data["type"]["exclude_name"].any? { |format| format === type_name }
      return false if data["type"]["exclude_file"].any? { |format| format === filepath }

      data["type"]["include_name"].any? { |format| format === type_name }
    end

    # rubocop:enable Style/CaseEquality
  end
end
