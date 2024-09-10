# Convert Ruby C function definition to Go source and dump to dist/
#
# Usage:
#   ruby_h_to_go.rb -H path/to/ruby/header/dir

require "optparse"
require "fileutils"
require "yaml"

header_dir = nil

opt = OptionParser.new
opt.on("-H HEADER_DIR") {|v| header_dir = v }

opt.parse!(ARGV)

# Use default header file and include paths
unless header_dir
  header_dir = RbConfig::CONFIG["rubyhdrdir"]
end

class Generator
  attr_reader :header_dir

  attr_reader :data

  # @param header_dir [String]
  def initialize(header_dir)
    @header_dir = header_dir
    @data = YAML.load_file(File.join(__dir__, "ruby_h_to_go.yml"))
  end

  def perform
    function_definitions = extract_function_definitions

    struct_definitions = extract_struct_definitions

    type_definitions = extract_type_definitions

    # Clean all generated files in dist/
    FileUtils.rm_f(Dir.glob(File.join(__dir__, "dist", "*.go")))

    type_definitions.each do |definition|
      write_type_to_go_file(
        filepath:  definition[:filepath],
        type_name: definition[:type_name],
      )
    end

    struct_definitions.each do |definition|
      write_type_to_go_file(
        filepath:  definition[:filepath],
        type_name: definition[:struct_name],
      )
    end

    function_definitions.each do |definition|
      write_function_to_go_file(
        filepath:      definition[:filepath],
        args:          definition[:args],
        typeref:       definition[:typeref],
        function_name: definition[:function_name],
        definition:    definition[:definition],
      )
    end

    FileUtils.cp(File.join(__dir__, "..", "..", "ruby", "c_types.go"), File.join(__dir__, "dist"))

    Dir.chdir(File.join(__dir__, "dist")) do
      system("go fmt", exception: true)
    end
  end

  private

  # @return [Array<Hash>]
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

      args = parse_definition_args(function_name, definition)

      # Exclude functions with variable-length arguments
      next if args&.last&.dig(:type) == "..."

      definitions << {
        definition:    definition,
        function_name: parts[0],
        filepath:      parts[1],
        typeref:       definition[0...definition.index(parts[0])].gsub("char *", "char*").strip,
        args:          args
      }
    end
  end

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

  # @return [Array<Hash>]
  def extract_struct_definitions
    stdout = `ctags --recurse --c-kinds=s --languages=C --language-force=C --fields=+n -f - #{header_dir}`

    stdout.each_line.each_with_object([]) do |line, definitions|
      parts = line.split("\t")

      struct_name = parts[0]

      next unless should_generate_struct?(struct_name)

      definitions << {
        struct_name: struct_name,
        filepath:    parts[1],
      }
    end
  end

  # Whether generate C struct to go
  # @param struct_name [String]
  # @return [Boolean]
  def should_generate_struct?(struct_name)
    struct_name = struct_name.downcase

    struct_name.start_with?("rb_")
  end

  # @return [Array<Hash>]
  def extract_type_definitions
    stdout = `ctags --recurse --c-kinds=t --languages=C --language-force=C --fields=+n -f - #{header_dir}`

    stdout.each_line.each_with_object([]) do |line, definitions|
      parts = line.split("\t")

      type_name = parts[0]

      next unless should_generate_type?(type_name)

      definitions << {
        type_name: type_name,
        filepath:  parts[1],
      }
    end.uniq { |definition| definition[:type_name] }
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
  def parse_definition_args(function_name, definition)
    definition =~ /(?<=\()(.+)(?=\))/
    args = $1.split(",").map(&:strip)

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
          {
            type: type,
            name: name,
          }
        end
      else
        if parts[-1].start_with?("*")
          parts[-1].delete_prefix!("*")
          parts[-2] << "*"
        end

        unless parts[-1] =~ /^[0-9a-zA-Z_]+$/
          # last elements isn't dummy argument
          parts << "arg#{arg_pos}"
        end

        type = parts[0...-1].join(" ")
        type = type.delete_prefix("const ")
        name = parts[-1]

        pointer = nil
        if type.end_with?("*")
          type.delete_suffix!("*")
          pointer = function_arg_pointer_hint(function_name, arg_pos-1)
        elsif /^void\s*\s/.match?(type)
          # function pointer (e.g. void *(*func)(void *)) is treated as `void*`
          type = "void"
          pointer = :ref
        end

        {
          type: type,
          name: name,
          pointer: pointer
        }
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

  # @param filepath [String]
  # @param args [Array<Hash>]
  # @param typeref [String]
  # @param function_name [String]
  # @param definition [String]
  def write_function_to_go_file(filepath:, args:, typeref:, function_name:, definition:)
    go_file_path = ruby_h_path_to_go_file_path(filepath)

    generate_initial_go_file(go_file_path)

    args.each do |c_arg|
      case c_arg[:name]
      when "var"
        # `var` is reserved in Go
        c_arg[:name] = "v"
      when "func"
        # `func` is reserved in Go
        c_arg[:name] = "fun"
      when "range"
        # `range` is reserved in Go
        c_arg[:name] = "r"
      end
    end

    go_function_name = snake_to_camel(function_name)
    go_function_args = args.map do |c_arg|
      "#{c_arg[:name]} #{ruby_c_type_to_go_type(c_arg[:type], pointer: c_arg[:pointer], type: :arg)}"
    end

    go_function_typeref =
      if typeref == "void"
        ""
      else
        ruby_c_type_to_go_type(typeref, type: :return)
      end

    go_function_lines = [
      "// #{go_function_name} calls `#{function_name}` in C",
      "//",
      "// Original definition is following",
      "//",
      "//\t#{definition}",
    ]

    go_function_lines << "func #{go_function_name}(#{go_function_args.join(", ")}) #{go_function_typeref} {"

    call_c_method = "C.#{function_name}("

    casted_go_args = []
    char_var_count = args.count { |c_arg| c_arg[:type] == "char" && c_arg[:pointer] }

    before_call_function_lines = []
    after_call_function_lines = []

    args.each do |c_arg|
      if c_arg[:type] == "char" && c_arg[:pointer]
        if char_var_count >= 2
          char_var_name = "char#{snake_to_camel(c_arg[:name])}"
          clean_var_name = "cleanChar#{(c_arg[:name])}"
        else
          char_var_name = "char"
          clean_var_name = "clean"
        end

        go_function_lines << "#{char_var_name}, #{clean_var_name} := string2Char(#{c_arg[:name]})"
        go_function_lines << "defer #{clean_var_name}()"
        go_function_lines << ""

        casted_go_args << "#{char_var_name}"
      else
        if c_arg[:pointer] == :ref
          if c_arg[:type] == "void"
            casted_go_args << "toCPointer(#{c_arg[:name]})"
          else
            c_var_name = "c#{snake_to_camel(c_arg[:name])}"

            before_call_function_lines << "var #{c_var_name} C.#{c_arg[:type]}"
            after_call_function_lines << "*#{c_arg[:name]} = #{ruby_c_type_to_go_type(c_arg[:type], type: :arg)}(#{c_var_name})"
            casted_go_args << "&#{c_var_name}"
          end
        else
          casted_go_args << "#{cast_to_cgo_type(c_arg[:type])}(#{c_arg[:name]})"
        end
      end
    end

    call_c_method << casted_go_args.join(", ")
    call_c_method << ")"

    if go_function_typeref == ""
      go_function_lines.push(*before_call_function_lines)
      go_function_lines << call_c_method
      go_function_lines.push(*after_call_function_lines)
    else
      go_function_lines.push(*before_call_function_lines)
      go_function_lines << "ret := #{ruby_c_type_to_go_type(typeref)}(#{call_c_method})"
      go_function_lines.push(*after_call_function_lines)
      go_function_lines << "return ret"
    end

    go_function_lines << "}"
    go_function_lines << ""
    go_function_lines << ""

    File.open(go_file_path, "a") do |f|
      f.write(go_function_lines.join("\n"))
    end
  end

  # @param ruby_h_path [String]
  # @return [String]
  def ruby_h_path_to_go_file_path(ruby_h_path)
    go_file_name = ruby_h_path.delete_prefix(header_dir + File::SEPARATOR).gsub(File::SEPARATOR, "-").gsub(/\.h$/, ".go")
    File.join(__dir__, "dist", go_file_name)
  end

  # Generate initial go file whether not exists
  # @param go_file_path [String]
  def generate_initial_go_file(go_file_path)
    return if File.exist?(go_file_path)

    File.open(go_file_path, "wb") do |f|
      f.write(<<~GO)
        package ruby

        /*
        #include "ruby.h"
        */
        import "C"

      GO
    end
  end

  # @param filepath [String]
  # @param type_name [String]
  def write_type_to_go_file(filepath:, type_name:)
    go_file_path = ruby_h_path_to_go_file_path(filepath)

    generate_initial_go_file(go_file_path)

    go_type_name = snake_to_camel(type_name)

    content = <<~GO
      // #{go_type_name} is a type for passing `C.#{type_name}` in and out of package
      type #{go_type_name} C.#{type_name}

    GO

    File.open(go_file_path, "a") do |f|
      f.write(content)
    end
  end

  # @param str [String]
  # @return [String]
  def snake_to_camel(str)
    return str if %w(VALUE ID).include?(str)
    str.split("_").map(&:capitalize).join.gsub(/(?<=\d)([a-z])/) { _1.upcase }
  end

  # Cast C type to cgo type. (Used in wrapper function)
  # @param typename [String]
  # @return [String]
  def cast_to_cgo_type(typename)
    case typename
    when "unsigned long"
      return "C.ulong"
    when "unsigned int"
      return "C.uint"
    when "VALUE*"
      return "toCValueArray"
    when /^VALUE\s*\(\*func\)\s*\(ANYARGS\)$/
      return "toCPointer"
    end

    "C.#{typename}"
  end

  # Convert C type to Go type. (used in wrapper function args and return type etc)
  # @param typename [String]
  # @param type [Symbol,nil] :arg, :return
  # @param pointer [Symbol,nil] Whether pointer hint
  # @return [String]
  def ruby_c_type_to_go_type(typename, type: nil, pointer: nil)
    if pointer
      case typename
      when "char", "const char"
        case type
        when :arg, :return
          return "string"
        else
          return "char2String"
        end
      when "void"
        return "unsafe.Pointer"
      end

      go_type_name = snake_to_camel(typename)

      return "[]#{go_type_name}" if pointer == :array

      return "*#{go_type_name}"
    end

    case typename
    when "unsigned int", "unsigned long"
      return "uint"
    when /^VALUE\s*\(\*func\)\s*\(ANYARGS\)$/
      return "unsafe.Pointer"
    when /^[A-Z]+$/, "int"
      # e.g. VALUE
      return typename
    end

    snake_to_camel(typename)
  end
end

Generator.new(header_dir).perform
