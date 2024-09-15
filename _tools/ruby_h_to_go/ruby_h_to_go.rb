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
    parser = RubyHeaderParser::Parser.new(header_dir)

    function_definitions = parser.extract_function_definitions.map { |d| RubyHToGo::FunctionDefinition.new(d) }
    struct_definitions   = parser.extract_struct_definitions.map { |d| RubyHToGo::StructDefinition.new(d) }
    type_definitions     = parser.extract_type_definitions.map { |d| RubyHToGo::TypeDefinition.new(d) }

    # Clean all generated files in dist/
    FileUtils.rm_f(Dir.glob(File.join(dist_dir, "*.go")))

    type_definitions.each do |definition|
      definition.write_go_file(dist_dir:, header_dir:)
    end

    struct_definitions.each do |definition|
      definition.write_go_file(dist_dir:, header_dir:)
    end

    function_definitions.each do |definition|
      definition.write_go_file(dist_dir:, header_dir:)
    end

    FileUtils.cp(File.join(__dir__, "..", "..", "ruby", "c_types.go"), dist_dir)

    Dir.chdir(File.join(__dir__, "dist")) do
      system("go fmt", exception: true)
    end
  end

  private

  def dist_dir
    File.join(__dir__, "dist")
  end
end

Generator.new(header_dir).perform
