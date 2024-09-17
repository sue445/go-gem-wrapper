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

      let(:args) do
        [
          "VALUE obj",
          "ID mid",
          "int argc",
          "const VALUE *argv",
          "rb_block_call_func_t proc",
          "VALUE data2",
        ]
      end

      it { should eq args }
    end

    context "with function pointer" do
      let(:signature) { "VALUE target_thread_not_supported_yet,rb_event_flag_t events,void (* func)(VALUE,void *),void * data" } # rubocop:disable Layout/LineLength

      let(:args) do
        [
          "VALUE target_thread_not_supported_yet",
          "rb_event_flag_t events",
          "void (* func)(VALUE,void *)",
          "void * data",
        ]
      end

      it { should eq args }
    end
  end

  describe ".sanitize_type" do
    subject { RubyHeaderParser::Util.sanitize_type(type) }

    using RSpec::Parameterized::TableSyntax
    where(:type, :expected) do
      "RUBY_EXTERN int"          | "int"
      "RUBY_EXTERN volatile int" | "int"
      "enum rb_io_buffer_flags"  | "rb_io_buffer_flags"
      "const char*"              | "char*"
      "volatile size_t"          | "size_t"
      "struct timeval"           | "timeval"
      "const char* const*"       | "char*"
    end

    with_them do
      it { should eq expected }
    end
  end
end
