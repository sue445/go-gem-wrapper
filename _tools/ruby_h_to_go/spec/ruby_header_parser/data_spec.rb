# frozen_string_literal: true

RSpec.describe RubyHeaderParser::Data do
  let(:data) { RubyHeaderParser::Data.new }

  describe "#function_arg_pointer_hint" do
    subject { data.function_arg_pointer_hint(function_name:, index:) }

    context "found in data.yml" do
      let(:function_name) { "rb_funcallv" }
      let(:index) { 3 }

      it { should eq :array }
    end

    context "not found in data.yml" do
      let(:function_name) { "rb_funcallv" }
      let(:index) { 4 }

      it { should eq :ref }
    end
  end
end
