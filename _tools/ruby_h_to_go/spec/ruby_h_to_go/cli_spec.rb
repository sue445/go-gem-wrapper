# frozen_string_literal: true

RSpec.describe RubyHToGo::Cli do
  include_context "uses temp dir"

  let(:cli) do
    RubyHToGo::Cli.new(
      header_file:                   File.join(RbConfig::CONFIG["rubyhdrdir"], "ruby.h"),
      include_paths:                 [RbConfig::CONFIG["rubyarchhdrdir"], RbConfig::CONFIG["rubyhdrdir"]],
      dist_dir:                      temp_dir,
      dist_preprocessed_header_file:
    )
  end

  let(:dist_preprocessed_header_file) { File.join(temp_dir, "ruby_preprocessed.h") }

  describe "#perform" do
    subject { cli.perform }

    before do
      FileUtils.cp(File.join(project_root_dir, "go.mod"), temp_dir)
    end

    it { expect { subject }.not_to raise_error }
  end
end
