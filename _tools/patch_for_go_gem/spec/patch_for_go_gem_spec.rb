# frozen_string_literal: true

RSpec.describe "patch_for_go_gem.rb" do
  gem_name = "new_gem"

  before(:all) do
    @temp_dir = Dir.mktmpdir

    Dir.chdir(@temp_dir) do
      sh "bundle gem #{gem_name} --ext=c"
      sh "ruby #{File.join(src_dir, "patch_for_go_gem.rb")} --file=#{File.join(gem_name, "#{gem_name}.gemspec")}"

      if ENV["CI"]
        [
          "#{gem_name}.c",
          "#{gem_name}.go",
          "go.mod",
          "extconf.rb",
        ].each do |file_name|
          file_path = File.join(gem_name, "ext", gem_name, file_name)
          puts "----------------------------------------"
          puts file_path
          puts "----------------------------------------"
          puts File.read(file_path)
          puts ""
        end
      end
    end
  end

  # @param command [String]
  def sh(command)
    puts "$ #{command}"
    system command, exception: true
  end

  after(:all) do
    FileUtils.remove_entry_secure(@temp_dir) if @temp_dir && Dir.exist?(@temp_dir)
  end

  around do |example|
    Dir.chdir(@temp_dir) do
      example.run
    end
  end

  describe file(File.join(gem_name, "ext", gem_name, "#{gem_name}.c")) do
    it { should be_file }
    it { should exist }
    its(:content) { should match(/^#include "_cgo_export.h"$/) }
    its(:content) { should_not match(/VALUE\s*rb/) }
    its(:content) { should_not include "RUBY_FUNC_EXPORTED void" }
    its(:content) { should_not match(/Init_.+\(void\)/) }
    its(:content) { should_not match(/rb_m.+\s*=\s*rb_define_module\(".+"\);/) }
  end

  describe file(File.join(gem_name, "ext", gem_name, "#{gem_name}.go")) do
    it { should be_file }
    it { should exist }

    let(:content) do
      <<~GO
        package main

        /*
        #include "#{gem_name}.h"
        */
        import "C"

      GO
    end

    its(:content) { should be_start_with content }
  end

  describe file(File.join(gem_name, "ext", gem_name, "go.mod")) do
    it { should be_file }
    it { should exist }

    let(:content) do
      <<~GO
        module github.com/username/#{gem_name}

      GO
    end

    its(:content) { should be_start_with content }
  end

  describe file(File.join(gem_name, "ext", gem_name, "extconf.rb")) do
    it { should be_file }
    it { should exist }

    its(:content) { should include %(require "go_gem/mkmf") }
    its(:content) { should include %(create_go_makefile("#{gem_name}/#{gem_name}")) }
    its(:content) { should_not include %(create_makefile("#{gem_name}/#{gem_name}")) }
  end

  describe file(File.join(gem_name, "#{gem_name}.gemspec")) do
    it { should be_file }
    it { should exist }

    its(:content) { should include %(spec.add_dependency "go_gem") }
  end
end
