# frozen_string_literal: true

RSpec.describe GoGem::Mkmf do
  describe "#create_go_makefile" do
    gem_name = "new_gem"

    before(:all) do
      @temp_dir = Dir.mktmpdir

      Dir.chdir(@temp_dir) do
        create_go_makefile("#{gem_name}/#{gem_name}")
      end
    end

    after(:all) do
      FileUtils.remove_entry_secure(@temp_dir) if @temp_dir && Dir.exist?(@temp_dir)
    end

    around do |example|
      Dir.chdir(@temp_dir) do
        example.run
      end
    end

    describe file("Makefile") do
      it { should be_file }
      it { should exist }

      # content of create_makefile
      its(:content) { should match(%r{^SHELL = /bin/sh$}) }

      # content of create_go_makefile
      its(:content) { should match(%r{^\$\(DLLIB\): Makefile \$\(srcdir\)/\*\.go$}) }
    end
  end
end
