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

  describe "#should_generate_function?" do
    subject { data.should_generate_function?(function_name) }

    context "rb function (denied)" do
      let(:function_name) { "rb_check_safe_str" }

      it { should eq false }
    end

    context "rb function (allowed)" do
      let(:function_name) { "rb_define_class" }

      it { should eq true }
    end

    context "no rb function" do
      let(:function_name) { "sprintf" }

      it { should eq false }
    end
  end

  describe "#should_generate_struct?" do
    subject { data.should_generate_struct?(struct_name) }

    context "rb struct" do
      let(:struct_name) { "rb_random_struct" }

      it { should eq true }
    end

    context "non rb struct" do
      let(:struct_name) { "fuga" }

      it { should eq false }
    end
  end
end
