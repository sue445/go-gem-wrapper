# frozen_string_literal: true

module RubyHeaderParser
  # parse `ruby.h` using `ctags`
  class Parser # rubocop:disable Metrics/ClassLength
    # @!attribute [r] header_file
    #   @return [String]
    attr_reader :header_file

    # @!attribute [r] include_paths
    #   @return [Array<String>]
    attr_reader :include_paths

    # @!attribute [r] dist_preprocessed_header_file
    #   @return [String]
    attr_reader :dist_preprocessed_header_file

    # @!attribute [r] data
    #   @return [RubyHeaderParser::Data]
    attr_reader :data

    # @param header_file [String] path to ruby.h
    # @param include_paths [Array<String>]
    # @param dist_preprocessed_header_file [String]
    def initialize(dist_preprocessed_header_file:, header_file: "#{RbConfig::CONFIG["rubyhdrdir"]}/ruby.h",
                   include_paths: [RbConfig::CONFIG["rubyarchhdrdir"], RbConfig::CONFIG["rubyhdrdir"]])
      @header_file = header_file
      @include_paths = include_paths
      @dist_preprocessed_header_file = dist_preprocessed_header_file
      @data = Data.new
    end

    # @return [Array<RubyHeaderParser::FunctionDefinition>]
    def extract_function_definitions
      __extract_function_definitions(c_kinds: "p", kind: "p", is_parse_multiline_definition: true)
    end

    # @return [Array<RubyHeaderParser::FunctionDefinition>]
    def extract_static_inline_function_definitions
      __extract_function_definitions(c_kinds: "+p-d", kind: "f", is_parse_multiline_definition: false)
    end

    # @return [Array<RubyHeaderParser::StructDefinition>]
    def extract_struct_definitions
      stdout = execute_ctags("--c-kinds=s --fields=+n")

      stdout.each_line.with_object([]) do |line, definitions|
        parts = line.split("\t")

        struct_name = parts[0]
        next unless data.should_generate_struct?(struct_name)

        definitions << StructDefinition.new(
          name: struct_name,
        )
      end
    end

    # @return [Array<RubyHeaderParser::TyperefDefinition>]
    def extract_type_definitions
      stdout = execute_ctags("--c-kinds=t --fields=+n")

      stdout.each_line.with_object([]) do |line, definitions|
        parts = line.split("\t")

        type_name = parts[0]

        next unless data.should_generate_type?(type_name)

        definitions << TypeDefinition.new(
          name: type_name,
        )
      end.uniq(&:name)
    end

    # @return [Array<RubyHeaderParser::EnumDefinition>]
    def extract_enum_definitions
      stdout = execute_ctags("--c-kinds=e --fields=+n")

      name_to_definitions =
        stdout.each_line.with_object({}) do |line, hash|
          parts = line.split("\t")

          enum_name = Util.find_field(parts, "enum")
          next unless enum_name

          value = parts[0]

          next unless data.should_generate_enum?(enum_name)

          hash[enum_name] ||= EnumDefinition.new(name: enum_name)
          hash[enum_name].values << value
        end

      name_to_definitions.values
    end

    private

    # @param c_kinds [String]
    # @param kind [String]
    # @param is_parse_multiline_definition [Boolean]
    # @return [Array<RubyHeaderParser::FunctionDefinition>]
    def __extract_function_definitions(c_kinds:, kind:, is_parse_multiline_definition:)
      stdout = execute_ctags("--c-kinds=#{c_kinds} --fields=+nS --extras=+q")

      stdout.each_line.map do |line|
        generate_function_definition_from_line(line:, kind:, is_parse_multiline_definition:)
      end.compact.uniq(&:name)
    end

    # @param line [String]
    # @param kind [String]
    # @param is_parse_multiline_definition [Boolean]
    #
    # @return [RubyHeaderParser::FunctionDefinition, nil]
    def generate_function_definition_from_line(line:, kind:, is_parse_multiline_definition:)
      parts = line.split("\t")

      function_name = parts[0]
      filepath = parts[1]

      return nil unless data.should_generate_function?(function_name)

      return nil unless parts[3] == kind

      line_num = Util.find_field(parts, "line").to_i
      definition = parse_function_definition(filepath:, pattern: parts[2], line_num:, is_parse_multiline_definition:)

      args = parse_definition_args(function_name, Util.find_field(parts, "signature"))

      # Exclude functions with variable-length arguments
      return nil if args&.last&.type == "..."

      typeref_field = Util.find_field(parts, "typeref:typename")

      FunctionDefinition.new(
        definition:,
        name:       function_name,
        typeref:    create_typeref(definition:, function_name:, typeref_field:, filepath:, line_num:),
        args:,
      )
    end

    # @param args [String]
    # @return [String]
    def execute_ctags(args = "")
      unless File.exist?(dist_preprocessed_header_file)
        include_args = include_paths.map { |path| "-I #{path}" }.join(" ")
        system("gcc -E #{include_args} #{header_file} -o #{dist_preprocessed_header_file}", exception: true)
      end

      `ctags --languages=C --language-force=C #{args} -f - #{dist_preprocessed_header_file}`
    end

    # @param file [String]
    # @param line_num [Integer]
    def read_definition_from_header_file(file, line_num)
      definition = +""

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

    # @param filepath [String]
    # @param pattern [String]
    # @param line_num [Integer]
    # @param is_parse_multiline_definition [Boolean]
    # @return [String]
    def parse_function_definition(filepath:, pattern:, line_num:, is_parse_multiline_definition:)
      definition =
        if pattern.end_with?("$/;\"")
          pattern.delete_prefix("/^").delete_suffix("$/;\"")
        elsif is_parse_multiline_definition
          read_definition_from_header_file(filepath, line_num)
        else
          pattern.delete_prefix("/^")
        end

      definition.strip.delete_suffix(";")
    end

    # @param function_name [String]
    # @param signature [String,nil]
    # @return [Array<RubyHeaderParser::ArgumentDefinition>]
    def parse_definition_args(function_name, signature)
      return [] unless signature

      signature = signature.strip.delete_prefix("(").delete_suffix(")")
      return [] if signature.match?(/^void$/i)

      args = Util.split_signature(signature)

      arg_pos = 0
      args.map do |arg|
        arg_pos += 1
        generate_argument_definition(function_name:, arg:, arg_pos:)
      end
    end

    # @param definition [String]
    # @param function_name [String]
    # @param typeref_field [String,nil]
    # @param filepath [String]
    # @param line_num [Integer]
    # @return [RubyHeaderParser::TyperefDefinition]
    def create_typeref(definition:, function_name:, typeref_field:, filepath:, line_num:)
      typeref_type = parse_typeref_type(definition:, function_name:, typeref_field:, filepath:, line_num:)

      typeref_pointer = nil
      if typeref_type.match?(/\*+$/)
        typeref_type = typeref_type.gsub(/\*+$/, "").strip
        typeref_pointer = data.function_self_pointer_hint(function_name)
      end

      TyperefDefinition.new(type: typeref_type, pointer: typeref_pointer)
    end

    # @param definition [String]
    # @param function_name [String]
    # @param typeref_field [String,nil]
    # @param filepath [String]
    # @param line_num [Integer]
    # @return [String]
    def parse_typeref_type(definition:, function_name:, typeref_field:, filepath:, line_num:)
      typeref_type =
        if typeref_field
          typeref_field.gsub(/[A-Z_]+\s*\(\(.*\)\)/, "").gsub("RUBY_SYMBOL_EXPORT_BEGIN", "")
        else
          # parse typeref in definition
          definition[0...definition.index(function_name)].gsub("char *", "char*").strip
        end

      typeref_type = Util.sanitize_type(typeref_type)
      return typeref_type unless typeref_type.empty?

      # Check prev line
      line = read_file_line(filepath:, line_num: line_num - 1)
      return Util.sanitize_type(line) if line

      ""
    end

    # @param filepath [String]
    # @param line_num [Integer]
    def read_file_line(filepath:, line_num:)
      return nil if line_num < 1

      lines = File.open(filepath, "rb") { |f| f.readlines(chomp: true) }
      lines[line_num - 1]
    end

    # @param function_name [String]
    # @param arg [String]
    # @param arg_pos [Integer]
    #
    # @return [ArgumentDefinition]
    def generate_argument_definition(function_name:, arg:, arg_pos:)
      parts = arg.split

      if parts.count < 2
        return ArgumentDefinition.new(
          type:    parts[0],
          name:    "arg#{arg_pos}",
          pointer: nil,
        )
      end

      loop do
        pointer_index = parts.index("*")
        break unless pointer_index

        parts[pointer_index - 1] << "*"
        parts.delete_at(pointer_index)
      end

      type, pointer, length = analyze_argument_type(function_name:, arg_pos:, parts:)

      ArgumentDefinition.new(
        name:    parts[-1],
        type:,
        pointer:,
        length:,
      )
    end

    # @param function_name [String]
    # @param arg_pos [Integer]
    # @param parts [Array<String>]
    #
    # @return [Array<String, Symbol, Integer>]
    #   - type [String]
    #   - pointer [Symbol]
    #   - length [Integer]
    def analyze_argument_type(function_name:, arg_pos:, parts:)
      pointer, length = prepare_argument_parts(arg_pos:, parts:)
      original_type = Util.sanitize_type(parts[0...-1].join(" "))

      case original_type
      when /\*+$/
        type = original_type.gsub(/\*+$/, "").strip
        pointer = data.function_arg_pointer_hint(function_name:, pos: arg_pos)

      when /^void\s*/, /\(.*\)/
        # function pointer (e.g. void *(*func)(void *)) is treated as `void*`
        type = "void"
        pointer = data.function_arg_pointer_hint(function_name:, pos: arg_pos)

      else
        type = original_type
      end

      length = pointer_length(original_type) if pointer == :sref

      [type, pointer, length]
    end

    # @param arg_pos [Integer]
    # @param parts [Array<String>]
    #
    # @return [Array<Symbol, Integer>]
    #   - pointer [Symbol,nil]
    #   - length [Integer]
    def prepare_argument_parts(parts:, arg_pos:)
      pointer = nil
      length = 0

      if parts[-1] =~ /\[([0-9]+)?\]$/
        parts[-1].gsub!(/\[([0-9]+)?\]$/, "")
        length = ::Regexp.last_match(1).to_i
        pointer = :array
      end

      unless parts[-1] =~ /^[0-9a-zA-Z_]+$/
        # last elements isn't dummy argument
        parts << "arg#{arg_pos}"
      end

      [pointer, length]
    end

    # @param type [String]
    def pointer_length(type)
      type =~ /(\*+)$/
      ::Regexp.last_match(1).length
    end
  end
end
