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
    # @param pos [Integer] arg position (1 origin)
    # @return [Symbol] :ref, :array, :ref_array, :function, :sref, :str_array, :in_ref
    def function_arg_pointer_hint(function_name:, pos:)
      pointer_hint = data["function"]["pointer_hint"].dig(function_name, pos)
      return pointer_hint.to_sym if pointer_hint

      :ref
    end

    # @param function_name [String]
    # @return [Symbol] :ref, :raw
    def function_self_pointer_hint(function_name)
      pointer_hint = data["function"]["pointer_hint"].dig(function_name, "self")
      return pointer_hint.to_sym if pointer_hint

      :ref
    end

    # rubocop:disable Style/CaseEquality

    # Whether generate C function to go
    # @param function_name [String]
    # @return [Boolean]
    def should_generate_function?(function_name)
      return false if data["function"]["exclude_name"].any? { |format| format === function_name }

      data["function"]["include_name"].any? { |format| format === function_name }
    end

    # Whether generate C struct to go
    # @param struct_name [String]
    # @return [Boolean]
    def should_generate_struct?(struct_name)
      return false if data["struct"]["exclude_name"].any? { |format| format === struct_name }

      data["struct"]["include_name"].any? { |format| format === struct_name }
    end

    # Whether generate C type to go
    # @param type_name [String]
    # @return [Boolean]
    def should_generate_type?(type_name)
      return false if data["type"]["exclude_name"].any? { |format| format === type_name }

      data["type"]["include_name"].any? { |format| format === type_name }
    end

    # Whether generate C enum to go
    # @param enum_name [String]
    # @return [Boolean]
    def should_generate_enum?(enum_name)
      return false if data["enum"]["exclude_name"].any? { |format| format === enum_name }

      data["enum"]["include_name"].any? { |format| format === enum_name }
    end

    # rubocop:enable Style/CaseEquality
  end
end
