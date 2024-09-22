# frozen_string_literal: true

RSpec.describe RubyHToGo::GeneratorHelper do
  include RubyHToGo::GeneratorHelper

  describe "#generate_go_file_name" do
    subject { generate_go_file_name(header_dir:, ruby_header_file:) }

    let(:header_dir) { "/path/to/include" }
    let(:ruby_header_file) { "/path/to/include/ruby/internal/intern/thread.h" }

    it { should eq "ruby_internal_intern_thread_generated.go" }
  end

  describe "#generate_include_github_url" do
    subject { generate_include_github_url(header_dir:, ruby_header_file:) }

    let(:header_dir) { "/path/to/include" }
    let(:ruby_header_file) { "/path/to/include/ruby/internal/intern/thread.h" }

    it { should eq "https://github.com/ruby/ruby/blob/master/include/ruby/internal/intern/thread.h" }
  end
end
