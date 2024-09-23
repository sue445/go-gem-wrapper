# frozen_string_literal: true

RSpec.describe RubyHToGo::Cli do
  include_context "uses temp dir"

  let(:cli) do
    RubyHToGo::Cli.new(
      header_dir: RbConfig::CONFIG["rubyhdrdir"],
      dist_dir:   temp_dir,
    )
  end

  describe "#write_type_definitions_to_go_file" do
    subject { cli.write_type_definitions_to_go_file }

    it { expect { subject }.not_to raise_error }
  end

  describe "#write_struct_definitions_to_go_file" do
    subject { cli.write_struct_definitions_to_go_file }

    it { expect { subject }.not_to raise_error }
  end

  describe "#write_function_definitions_to_go_file" do
    subject { cli.write_function_definitions_to_go_file }

    it { expect { subject }.not_to raise_error }
  end
end
