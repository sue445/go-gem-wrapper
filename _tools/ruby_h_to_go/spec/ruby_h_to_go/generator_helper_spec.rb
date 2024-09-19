# frozen_string_literal: true

RSpec.describe RubyHToGo::GeneratorHelper do
  include RubyHToGo::GeneratorHelper

  describe "#go_file_name" do
    subject { go_file_name(header_dir:, ruby_header_file:) }

    let(:header_dir) { "/path/to/include" }
    let(:ruby_header_file) { "/path/to/include/ruby/internal/intern/thread.h" }

    it { should eq "ruby-internal-intern-thread.go" }
  end
end
