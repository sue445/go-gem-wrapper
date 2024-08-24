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

# Create c-for-go config file from ruby.yml.erb
# @param rubyhdrdir [String]
# @param rubyarchhdrdir [String]
def create_c_for_go_config_file(rubyhdrdir:, rubyarchhdrdir:)
  include_paths = [
    rubyarchhdrdir,
    "#{rubyhdrdir}/ruby/backward",
    rubyhdrdir,
  ]

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
