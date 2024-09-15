# frozen_string_literal: true
module RubyHeaderParser
  # parse `ruby.h` using `ctags`
  class Parser
    # @!attribute [r] header_dir
    #   @return [String]
    attr_reader :header_dir

    # @!attribute [r] data
    #   @return [Hash]
    attr_reader :data

    # @param header_dir [String]
    def initialize(header_dir)
      @header_dir = header_dir
      @data = YAML.load_file(File.join(__dir__, "ruby_header_parser.yml"))
    end

    # @return [Array<RubyHeaderParser::FunctionDefinition>]
    def extract_function_definitions
      stdout = `ctags --recurse --c-kinds=p --languages=C --language-force=C --fields=+n --extras=+q -f - #{header_dir}`

      stdout.each_line.each_with_object([]) do |line, definitions|
        parts = line.split("\t")

        function_name = parts[0]

        next unless should_generate_function?(function_name)

        definition =
          if parts[2].end_with?(";$/;\"")
            parts[2].delete_prefix("/^").delete_suffix(";$/;\"")
          else
            line_num = parts[4].delete_prefix("line:").to_i
            read_definition_from_header_file(parts[1], line_num).delete_suffix(";")
          end

        definition.gsub!(/\);.*/, ")")

        args = parse_definition_args(function_name, definition)

        # Exclude functions with variable-length arguments
        next if args&.last&.type == "..."

        typeref_type = definition[0...definition.index(parts[0])].gsub("char *", "char*").strip
        typeref_pointer = nil
        if typeref_type.match?(/\*+$/)
          typeref_type = typeref_type.gsub(/\*+$/, "").strip
          typeref_pointer = :ref
        end

        typeref = TyperefDefinition.new(type: typeref_type, pointer: typeref_pointer)

        definitions << FunctionDefinition.new(
          definition:,
          name:       parts[0],
          filepath:   parts[1],
          typeref:,
          args:,
        )
      end
    end

    # @return [Array<RubyHeaderParser::StructDefinition>]
    def extract_struct_definitions
      stdout = `ctags --recurse --c-kinds=s --languages=C --language-force=C --fields=+n -f - #{header_dir}`

      stdout.each_line.each_with_object([]) do |line, definitions|
        parts = line.split("\t")

        struct_name = parts[0]

        next unless should_generate_struct?(struct_name)

        definitions << StructDefinition.new(
          name:     struct_name,
          filepath: parts[1],
        )
      end
    end

    # @return [Array<RubyHeaderParser::TyperefDefinition>]
    def extract_type_definitions
      stdout = `ctags --recurse --c-kinds=t --languages=C --language-force=C --fields=+n -f - #{header_dir}`

      stdout.each_line.each_with_object([]) do |line, definitions|
        parts = line.split("\t")

        type_name = parts[0]

        next unless should_generate_type?(type_name)

        definitions << TypeDefinition.new(
          name:     type_name,
          filepath: parts[1],
        )
      end.uniq(&:name)
    end

    private

    ALLOW_FUNCTION_NAME_PREFIXES = %w[rb_ rstring_]

    DENY_FUNCTION_NAMES = [
      # deprecated functions
      "rb_check_safe_str",
      "rb_clear_constant_cache",
      "rb_clone_setup",
      "rb_complex_polar",
      "rb_data_object_alloc",
      "rb_data_object_get_warning",
      "rb_data_object_wrap_warning",
      "rb_data_typed_object_alloc",
      "rb_dup_setup",
      "rb_gc_force_recycle",
      "rb_iterate",
      "rb_obj_infect",
      "rb_obj_infect_raw",
      "rb_obj_taint",
      "rb_obj_taint_raw",
      "rb_obj_taintable",
      "rb_obj_tainted",
      "rb_obj_tainted_raw",
      "rb_scan_args_length_mismatch",
      "rb_varargs_bad_length",

      # internal functions in ruby.h
      "rb_scan_args_bad_format",
    ]

    # Whether generate C function to go
    # @param function_name [String]
    # @return [Boolean]
    def should_generate_function?(function_name)
      function_name = function_name.downcase

      return false if DENY_FUNCTION_NAMES.include?(function_name)

      return true if ALLOW_FUNCTION_NAME_PREFIXES.any? { |prefix| function_name.start_with?(prefix) }

      false
    end

    # @param file [String]
    # @param line_num [Integer]
    def read_definition_from_header_file(file, line_num)
      definition = ""

      File.open(file, "r") do |f|
        f.each_with_index do |line, index|
          if index + 1 >= line_num
            definition << line.strip
            return definition if definition.end_with?(");")
          end
        end
      end
      ""
    end

    # Whether generate C struct to go
    # @param struct_name [String]
    # @return [Boolean]
    def should_generate_struct?(struct_name)
      struct_name = struct_name.downcase

      struct_name.start_with?("rb_")
    end

    ALLOW_TYPE_NAME_PREFIXES = %w[rb_ st_]
    ALLOW_TYPE_NAMES = %w[id value long_long]

    # Whether generate C type to go
    # @param type_name [String]
    # @return [Boolean]
    def should_generate_type?(type_name)
      type_name = type_name.downcase

      return true if ALLOW_TYPE_NAME_PREFIXES.any? { |prefix| type_name.start_with?(prefix) }

      ALLOW_TYPE_NAMES.include?(type_name)
    end

    # @param function_name [String]
    # @param definition [String]
    # @return [Array<RubyHeaderParser::ArgumentDefinition>]
    def parse_definition_args(function_name, definition)
      definition =~ /(?<=\()(.+)(?=\))/
      args = ::Regexp.last_match(1).split(",").map(&:strip)

      arg_pos = 0
      args.map do |str|
        arg_pos += 1
        parts = str.split(" ")

        if parts.count < 2
          type = parts[0]

          if type =~ /^void$/i
            nil
          else
            name = "arg#{arg_pos}"

            ArgumentDefinition.new(
              type:,
              name:,
              pointer: nil,
            )
          end
        else
          loop do
            break unless parts[-1].start_with?("*")

            parts[-1].delete_prefix!("*")
            parts[-2] << "*"
          end

          unless parts[-1] =~ /^[0-9a-zA-Z_]+$/
            # last elements isn't dummy argument
            parts << "arg#{arg_pos}"
          end

          type = parts[0...-1].join(" ")
          type = type.delete_prefix("const ").delete_prefix("volatile ").delete_prefix("struct ").strip
          name = parts[-1]

          pointer = nil
          if type.match?(/\*+$/)
            type = type.gsub(/\*+$/, "").strip
            pointer = function_arg_pointer_hint(function_name, arg_pos - 1)
          elsif /^void\s*\s/.match?(type) || /\(.*\)/.match?(type)
            # function pointer (e.g. void *(*func)(void *)) is treated as `void*`
            type = "void"
            pointer = :ref
          end

          ArgumentDefinition.new(
            type:,
            name:,
            pointer:,
          )
        end
      end.compact
    end

    # @param function_name [String]
    # @param index [Integer] arg position
    # @return [Symbol] :ref, :array
    def function_arg_pointer_hint(function_name, index)
      pointer_hint = data["pointer_hint"]["function"].dig(function_name, index)
      return pointer_hint.to_sym if pointer_hint

      :ref
    end
  end
end
