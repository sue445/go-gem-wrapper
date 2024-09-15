# Convert Ruby C function definition to Go source and dump to dist/
#
# Usage:
#   ruby_h_to_go.rb -H path/to/ruby/header/dir

require "optparse"
require "fileutils"

require_relative "lib/ruby_h_to_go"

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

  # @param header_dir [String]
  def initialize(header_dir)
    @header_dir = header_dir
  end

  def perform
    parser = RubyHeaderParser::Parser.new(header_dir)

    function_definitions = parser.extract_function_definitions.map { |d| RubyHToGo::FunctionDefinition.new(d) }
    struct_definitions   = parser.extract_struct_definitions.map { |d| RubyHToGo::StructDefinition.new(d) }
    type_definitions     = parser.extract_type_definitions.map { |d| RubyHToGo::TypeDefinition.new(d) }

    # Clean all generated files in dist/
    FileUtils.rm_f(Dir.glob(File.join(__dir__, "dist", "*.go")))

    type_definitions.each do |definition|
      write_type_to_go_file(definition)
    end

    struct_definitions.each do |definition|
      write_type_to_go_file(definition)
    end

    function_definitions.each do |definition|
      write_function_to_go_file(definition)
    end

    FileUtils.cp(File.join(__dir__, "..", "..", "ruby", "c_types.go"), File.join(__dir__, "dist"))

    Dir.chdir(File.join(__dir__, "dist")) do
      system("go fmt", exception: true)
    end
  end

  private

  # @param definition [RubyHToGo::FunctionDefinition]
  def write_function_to_go_file(definition)
    go_file_path = ruby_h_path_to_go_file_path(definition.filepath)

    generate_initial_go_file(go_file_path)

    definition.args.each do |c_arg|
      case c_arg.name
      when "var"
        # `var` is reserved in Go
        c_arg.name = "v"
      when "func"
        # `func` is reserved in Go
        c_arg.name = "fun"
      when "range"
        # `range` is reserved in Go
        c_arg.name = "r"
      when "type"
        # `type` is reserved in Go
        c_arg.name = "t"
      end
    end

    go_function_name = snake_to_camel(definition.name)
    go_function_args = definition.args.map do |c_arg|
      "#{c_arg.name} #{ruby_c_type_to_go_type(c_arg.type, pointer: c_arg.pointer, type: :arg)}"
    end

    go_function_typeref =
      if definition.typeref.type == "void" && !definition.typeref.pointer?
        ""
      else
        ruby_c_type_to_go_type(definition.typeref.type, type: :return, pointer: definition.typeref.pointer)
      end

    go_function_lines = [
      "// #{go_function_name} calls `#{definition.name}` in C",
      "//",
      "// Original definition is following",
      "//",
      "//\t#{definition.definition}",
    ]

    go_function_lines << "func #{go_function_name}(#{go_function_args.join(", ")}) #{go_function_typeref} {"

    call_c_method = "C.#{definition.name}("

    casted_go_args = []
    char_var_count = definition.args.count { |c_arg| c_arg.type == "char" && c_arg.pointer }

    before_call_function_lines = []
    after_call_function_lines = []

    definition.args.each do |c_arg|
      if c_arg.type == "char" && c_arg.pointer?
        if char_var_count >= 2
          char_var_name = "char#{snake_to_camel(c_arg.name)}"
          clean_var_name = "cleanChar#{(c_arg.name)}"
        else
          char_var_name = "char"
          clean_var_name = "clean"
        end

        go_function_lines << "#{char_var_name}, #{clean_var_name} := string2Char(#{c_arg.name})"
        go_function_lines << "defer #{clean_var_name}()"
        go_function_lines << ""

        casted_go_args << "#{char_var_name}"
      else
        if c_arg.pointer == :ref
          if c_arg.type == "void"
            casted_go_args << "toCPointer(#{c_arg.name})"
          else
            c_var_name = "c#{snake_to_camel(c_arg.name)}"

            before_call_function_lines << "var #{c_var_name} C.#{c_arg.type}"
            after_call_function_lines << "*#{c_arg.name} = #{ruby_c_type_to_go_type(c_arg.type, type: :arg)}(#{c_var_name})"
            casted_go_args << "&#{c_var_name}"
          end
        else
          casted_go_args << "#{cast_to_cgo_type(c_arg.type)}(#{c_arg.name})"
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
      go_function_lines << "ret := #{go_function_typeref}(#{call_c_method})"
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

  # @param definition [RubyHToGo::TypeDefinition,RubyHToGo::StructDefinition]
  def write_type_to_go_file(definition)
    go_file_path = ruby_h_path_to_go_file_path(definition.filepath)

    generate_initial_go_file(go_file_path)

    go_type_name = snake_to_camel(definition.name)

    content = <<~GO
      // #{go_type_name} is a type for passing `C.#{definition.name}` in and out of package
      type #{go_type_name} C.#{definition.name}

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
    when "unsigned char"
      return "C.uchar"
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
    typename = typename.delete_prefix("struct ").delete_prefix("volatile ")

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

      go_type_name = ruby_c_type_to_go_type(typename, type: type, pointer: nil)

      return "[]#{go_type_name}" if pointer == :array

      return "*#{go_type_name}"
    end

    case typename
    when "unsigned int", "unsigned long"
      return "uint"
    when "unsigned char"
      return "Uchar"
    when /^VALUE\s*\(\*func\)\s*\(ANYARGS\)$/
      return "unsafe.Pointer"
    when /^[A-Z]+$/, "int"
      # e.g. VALUE
      return typename
    when "void"
      return "unsafe.Pointer" if pointer == :ref && type == :return
    end

    snake_to_camel(typename)
  end
end

Generator.new(header_dir).perform
