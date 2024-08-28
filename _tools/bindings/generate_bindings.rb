# Generate C-Go Bindings from "ruby.h"
#
# Requirements
#   * https://github.com/xlab/c-for-go
#     *  go install github.com/xlab/c-for-go@latest
#
# Usage
#   ruby generate_bindings.rb

require "optparse"
require "erb"

SRC_CONFIG_ERB_FILE = File.join(__dir__, "ruby.yml.erb")
DIST_CONFIG_FILE = File.join(__dir__, "ruby.generated.yml")

rubyhdrdir = nil
rubyarchhdrdir = nil

opt = OptionParser.new
opt.on("--rubyhdrdir HEADER_DIR") {|v| rubyhdrdir = v }
opt.on("--rubyarchhdrdir HEADER_DIR") {|v| rubyarchhdrdir = v }

opt.parse!(ARGV)

# Use default header file and include paths
unless rubyhdrdir
  rubyhdrdir = RbConfig::CONFIG["rubyhdrdir"]
end

unless rubyarchhdrdir
  rubyarchhdrdir = RbConfig::CONFIG["rubyarchhdrdir"]
end

# Returns all header files included in ruby.h
# @param rubyhdrdir [String]
# @param rubyarchhdrdir [String]
# @return [Array<String>]
def included_ruby_header_files(rubyhdrdir:, rubyarchhdrdir:)
  result = `gcc -M -I#{rubyarchhdrdir} -I#{rubyhdrdir}/ruby/backward -I#{rubyhdrdir} #{rubyhdrdir}/ruby.h`
  header_files = result.delete_prefix("ruby.o:").lines.map do |line|
    line.gsub("\\\n", "").strip
  end

  header_files.select do |file|
    [rubyhdrdir, rubyarchhdrdir].any? { |dir| file.start_with?(dir) }
  end
end

# Create c-for-go config file from ruby.yml.erb
# @param rubyhdrdir [String]
# @param rubyarchhdrdir [String]
def create_c_for_go_config_file(rubyhdrdir:, rubyarchhdrdir:)
  # Define variables for ruby.yml.erb
  include_paths = [
    rubyarchhdrdir,
    "#{rubyhdrdir}/ruby/backward",
    rubyhdrdir,
  ]

  source_paths = included_ruby_header_files(rubyhdrdir:, rubyarchhdrdir:)

  config = ERB.new(File.read(SRC_CONFIG_ERB_FILE)).result(binding)

  File.open(DIST_CONFIG_FILE, "wb") do |f|
    f.write(config)
  end
end

# @param command [String]
def sh(command)
  puts "$ #{command}"
  system command, exception: true
end

def run_c_for_go
  sh "c-for-go -ccincl -nostamp -out #{__dir__} #{DIST_CONFIG_FILE}"
end

create_c_for_go_config_file(rubyhdrdir:, rubyarchhdrdir:)
run_c_for_go
