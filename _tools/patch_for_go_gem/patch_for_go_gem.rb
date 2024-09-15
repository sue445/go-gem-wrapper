require "optparse"

gemspec_file = nil
dry_run = false

opt = OptionParser.new
opt.on("-f", "--file=GEMSPEC_FILE") { |v| gemspec_file = v }
opt.on("--dry-run") { |v| dry_run = v }

opt.parse!(ARGV)

raise "--file is required" unless gemspec_file
raise "#{gemspec_file} isn't gemspec" unless File.extname(gemspec_file) == ".gemspec"
raise "#{gemspec_file} isn't found" unless File.exist?(gemspec_file)

class GemPatcher
  attr_reader :gemspec_file

  # @param gemspec_file [String]
  # @param dry_run [Boolean]
  def initialize(gemspec_file:, dry_run:)
    @gemspec_file = gemspec_file
    @dry_run = dry_run
  end

  def perform
    create_gem_name_go
    create_go_mod
    update_gem_name_c
    update_extconf_rb
  end

  private

  # @return [Boolean]
  def dry_run?
    @dry_run
  end

  # @return [String] path to ext dir. (e.g. /path/to/gem_name/ext/gem_name)
  def ext_dir
    File.join(File.absolute_path(File.dirname(gemspec_file)), "ext", gem_name)
  end

  # @return [String]
  def gem_name
    File.basename(gemspec_file, ".gemspec")
  end

  # @return [String]
  def module_name
    snake_to_camel(gem_name)
  end

  # @param str [String]
  # @return [String]
  def snake_to_camel(str)
    str.split("_").map(&:capitalize).join.gsub(/(?<=\d)([a-z])/) { _1.upcase }
  end

  # Create <gem_name>.go
  def create_gem_name_go
    gem_name_go_path = File.join(ext_dir, "#{gem_name}.go")

    return if File.exist?(gem_name_go_path)

    content = <<~GO
      package main

      /*
      #include "#{gem_name}.h"
      */
      import "C"

      import (
      \truby "github.com/sue445/go-gem-wrapper"
      )

      //export Init_#{gem_name}
      func Init_#{gem_name}() {
      \trb_m#{module_name} := ruby.RbDefineModule("#{module_name}")
      }

      func main() {
      }
    GO

    save_file(file_path: gem_name_go_path, content:)
  end

  def create_go_mod
    go_mod_path = File.join(ext_dir, "go.mod")

    return if File.exist?(go_mod_path)

    `go version` =~ /go version go([.\d]+)/
    go_version = $1

    raise "go isn't found in PATH" unless go_version

    content = <<~GO
      module github.com/username/#{gem_name}

      go #{go_version}
    GO

    save_file(file_path: go_mod_path, content:)
  end

  def update_gem_name_c
    gem_name_c_path = File.join(ext_dir, "#{gem_name}.c")

    content = File.read(gem_name_c_path)

    return if content.include?('#include "_cgo_export.h"')

    content = <<~C
      #include "#{gem_name}.h"
      #include "_cgo_export.h"
    C

    save_file(file_path: gem_name_c_path, content:)
  end

  def update_extconf_rb
    extconf_rb_path = File.join(ext_dir, "extconf.rb")

    content = File.read(extconf_rb_path)

    unless content.include?(<<~RUBY)
      require "mkmf"

      find_executable("go")
    RUBY

      content.gsub!(<<~RUBY, <<~RUBY)
        require "mkmf"
      RUBY
        require "mkmf"

        find_executable("go")

        # rubocop:disable Style/GlobalVars
        $objs = []
        def $objs.empty?; false; end
        # rubocop:enable Style/GlobalVars

      RUBY
    end

    unless content.include?(<<~RUBY)
      create_makefile("#{gem_name}/#{gem_name}")

      case `\#{CONFIG["CC"]} --version` # rubocop:disable Lint/LiteralAsCondition
    RUBY

      content.gsub!(<<~RUBY, <<~RUBY)
        create_makefile("#{gem_name}/#{gem_name}")
      RUBY
        create_makefile("#{gem_name}/#{gem_name}")

        case `\#{CONFIG["CC"]} --version` # rubocop:disable Lint/LiteralAsCondition
        when /Free Software Foundation/
          ldflags = "-Wl,--unresolved-symbols=ignore-all"
        when /clang/
          ldflags = "-undefined dynamic_lookup"
        end

        current_dir = File.expand_path(".")

        File.open("Makefile", "a") do |f|
          f.write <<~MAKEFILE.gsub(/^ {8}/, "\t")
            $(DLLIB): Makefile $(srcdir)/*.go
                    cd $(srcdir); \
                    CGO_CFLAGS='$(INCFLAGS)' CGO_LDFLAGS='\#{ldflags}' \\
                      go build -p 4 -buildmode=c-shared -o \#{current_dir}/$(DLLIB)
          MAKEFILE
        end

      RUBY
    end

    save_file(file_path: extconf_rb_path, content:)
  end

  # @param file_path [String]
  # @param content [String]
  def save_file(file_path:, content:)
    is_updated = File.exist?(file_path)
    if is_updated
      before_content = File.read(file_path)
      return if content == before_content
    end

    if dry_run?
      if is_updated
        puts "[INFO] #{file_path} will be updated (dry-run)"
      else
        puts "[INFO] #{file_path} will be created (dry-run)"
      end

      return
    end

    File.binwrite(file_path, content)

    if is_updated
      puts "[INFO] #{file_path} is updated"
    else
      puts "[INFO] #{file_path} is created"
    end
  end
end

GemPatcher.new(gemspec_file:, dry_run:).perform
