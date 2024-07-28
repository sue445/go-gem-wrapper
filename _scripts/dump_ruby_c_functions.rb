# Convert Ruby C function definition to Go source and dump to dist/
#
# Usage:
#   dump_ruby_c_functions.rb -H path/to/ruby/header/dir
#
# Requirements
# * Go
# * ctags
#   * NOTE: `universal-ctags` is required when MacOS
#   * c.f. https://formulae.brew.sh/formula/universal-ctags

require "optparse"
require "fileutils"

header_dir = nil

opt = OptionParser.new
opt.on("-H HEADER_DIR") {|v| header_dir = v }

opt.parse!(ARGV)

# Use default header file and include paths
unless header_dir
  header_dir = RbConfig::CONFIG["rubyhdrdir"]
end

# @param header_dir [String]
# @return [Array<Hash>]
def extract_function_definitions(header_dir)
  stdout = `ctags --recurse --c-kinds=p --languages=C --language-force=C --fields=+n --extras=+q -f - #{header_dir}`

  lines = stdout.each_line.select { |line| line.start_with?("rb_") }
  lines.map do |line|
    parts = line.split("\t")

    definition =
      if parts[2].end_with?(";$/;\"")
        parts[2].delete_prefix("/^").delete_suffix(";$/;\"")
      else
        line_num = parts[4].delete_prefix("line:").to_i
        read_definition_from_header_file(parts[1], line_num).delete_suffix(";")
      end

    {
      definition: definition,
      function_name: parts[0],
      filepath: parts[1],
      typeref: definition[0...definition.index(parts[0])].gsub("char *", "char*").strip,
      args:parse_definition_args(definition)
    }
  end
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

# @param definition [String]
def parse_definition_args(definition)
  definition =~ /(?<=\()(.+)(?=\))/
  args = $1.split(",").map(&:strip)

  arg_pos = 0
  args.map do |str|
    arg_pos += 1
    parts = str.split(" ")

    if parts.count < 2
      type = parts[0]
      name = "arg#{arg_pos}"
    else
      type = parts[0...-1].join(" ")
      type = type.delete_prefix("const ")

      name = parts[-1]
      if name.start_with?("*")
        name = name.delete_prefix("*")
        type << "*"
      end
    end

    {
      type: type,
      name: name,
    }
  end
end

function_definitions = extract_function_definitions(header_dir)

# @param definition [Hash]
# @param header_dir [String]
def generate_go_file(definition:, header_dir:)
  go_file_name = definition[:filepath].delete_prefix(header_dir + File::SEPARATOR).gsub(File::SEPARATOR, "-").gsub(/\.h$/, ".go")
  go_file_path = File.join(__dir__, "dist", go_file_name)

  unless File.exist?(go_file_path)
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

  go_function_name = snake_to_camel(definition[:function_name])
  go_function_args = definition[:args].map do |c_arg|
    "#{c_arg[:name]} #{ruby_c_type_to_go_type(c_arg[:type])}"
  end

  go_function_typeref =
    if definition[:typeref] == "void"
      ""
    else
      ruby_c_type_to_go_type(definition[:typeref])
    end

  go_function_lines = [
    "// #{go_function_name} calls `#{definition[:function_name]}` in C",
    "//",
    "// Original definition is following",
    "//",
    "//\t#{definition[:definition]}",
  ]

  go_function_lines << "func #{go_function_name}(#{go_function_args.join(", ")}) #{go_function_typeref} {"

  call_c_method = "C.#{definition[:function_name]}("
  casted_go_args = definition[:args].map do |c_arg|
    # Cast Go type to C type
    type =
      case c_arg[:type]
      when "unsigned long"
        "C.ulong"
      when "unsigned int"
        "C.uint"
      when "char*"
        "string2Char"
      else
        "C.#{c_arg[:type]}"
      end

    "#{type}(#{c_arg[:name]})"
  end
  call_c_method << casted_go_args.join(", ")
  call_c_method << ")"

  if go_function_typeref == ""
    go_function_lines << call_c_method
  else
    go_function_lines << "return #{ruby_c_type_to_go_type(definition[:typeref])}(#{call_c_method})"
  end

  go_function_lines << "}"
  go_function_lines << ""
  go_function_lines << ""

  File.open(go_file_path, "a") do |f|
    f.write(go_function_lines.join("\n"))
  end
end

# @param str [String]
# @return [String]
def snake_to_camel(str)
  str.split("_").map(&:capitalize).join
end

# @param typename [String]
# @return [String]
def ruby_c_type_to_go_type(typename)
  case typename
  when "unsigned int", "unsigned long"
    return "uint"
  when "char*", "const char*"
    return "string"
  when /^[A-Z]+$/
    # e.g. VALUE
    return typename
  end

  snake_to_camel(typename)
end

# Clean all generated files in dist/
FileUtils.rm_f(Dir.glob(File.join(__dir__, "dist", "*.go")))

function_definitions.each do |definition|
  generate_go_file(definition:,header_dir:)
end

Dir.chdir(File.join(__dir__, "dist")) do
  system("go fmt", exception: true)
end
