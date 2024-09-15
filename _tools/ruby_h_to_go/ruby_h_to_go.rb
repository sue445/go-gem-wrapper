# frozen_string_literal: true

# Convert Ruby C function definition to Go source and dump to dist/
#
# Usage:
#   ruby_h_to_go.rb -H path/to/ruby/header/dir

require "optparse"
require "fileutils"

require_relative "lib/ruby_h_to_go"

header_dir = nil

opt = OptionParser.new
opt.on("-H HEADER_DIR") { |v| header_dir = v }

opt.parse!(ARGV)

# Use default header file and include paths
header_dir ||= RbConfig::CONFIG["rubyhdrdir"]

class Generator # rubocop:disable Style/Documentation
  attr_reader :header_dir

  # @param header_dir [String]
  def initialize(header_dir)
    @header_dir = header_dir
  end

  def perform
    clean_generated_files

    write_type_definitions_to_go_file
    write_struct_definitions_to_go_file
    write_function_definitions_to_go_file

    FileUtils.cp(File.join(__dir__, "..", "..", "ruby", "c_types.go"), dist_dir)

    go_fmt
  end

  private

  # @return [RubyHeaderParser::Parser]
  def parser
    @parser ||= RubyHeaderParser::Parser.new(header_dir)
  end

  def write_type_definitions_to_go_file
    type_definitions = parser.extract_type_definitions.map { |d| RubyHToGo::TypeDefinition.new(d) }
    type_definitions.each do |definition|
      definition.write_go_file(dist_dir:, header_dir:)
    end
  end

  def write_struct_definitions_to_go_file
    struct_definitions = parser.extract_struct_definitions.map { |d| RubyHToGo::StructDefinition.new(d) }
    struct_definitions.each do |definition|
      definition.write_go_file(dist_dir:, header_dir:)
    end
  end

  def write_function_definitions_to_go_file
    function_definitions = parser.extract_function_definitions.map { |d| RubyHToGo::FunctionDefinition.new(d) }
    function_definitions.each do |definition|
      definition.write_go_file(dist_dir:, header_dir:)
    end
  end

  def dist_dir
    File.join(__dir__, "dist")
  end

  # Clean all generated files in dist/
  def clean_generated_files
    FileUtils.rm_f(Dir.glob(File.join(dist_dir, "*.go")))
  end

  def go_fmt
    Dir.chdir(dist_dir) do
      system("go fmt", exception: true)
    end
  end
end

Generator.new(header_dir).perform
