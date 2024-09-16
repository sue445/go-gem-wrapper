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

  describe ".split_signature" do
    subject { RubyHeaderParser::Util.split_signature(signature) }

    context "simple case" do
      let(:signature) { "VALUE obj, ID mid, int argc, const VALUE *argv, rb_block_call_func_t proc, VALUE data2" }

      it { should eq ["VALUE obj", "ID mid", "int argc", "const VALUE *argv", "rb_block_call_func_t proc", "VALUE data2"] }
    end

    context "with function pointer" do
      let(:signature) { "VALUE target_thread_not_supported_yet,rb_event_flag_t events,void (* func)(VALUE,void *),void * data" }

      it { should eq ["VALUE target_thread_not_supported_yet", "rb_event_flag_t events", "void (* func)(VALUE,void *)", "void * data"] }
    end
  end
end
