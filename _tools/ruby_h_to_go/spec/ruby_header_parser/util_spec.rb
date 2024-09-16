# frozen_string_literal: true

RSpec.describe RubyHeaderParser::Util do
  describe ".find_field" do
    subject { RubyHeaderParser::Util.find_field(array, field_name) }

    let(:array) { %w[a b foo:bar] }

    context "when exists field" do
      let(:field_name) { "foo" }

      it { should eq "bar" }
    end

    context "when not exists field" do
      let(:field_name) { "unknown" }

      it { should eq nil }
    end
  end
end
