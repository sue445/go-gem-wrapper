# frozen_string_literal: true

RSpec.describe RubyHeaderParser::Parser do
  let(:parser) { RubyHeaderParser::Parser.new(RbConfig::CONFIG["rubyhdrdir"]) }

  describe "#extract_function_definitions" do
    subject(:definitions) { parser.extract_function_definitions }

    its(:count) { should be > 0 }

    context "rb_define_method" do
      subject { definitions.find { |d| d.name == "rb_define_method" } }

      let(:args) do
        [
          argument(type: "VALUE", name: "klass"),
          argument(type: "char", name: "mid", pointer: :ref),
          argument(type: "void", name: "arg3", pointer: :ref),
          argument(type: "int", name: "arity"),
        ]
      end

      its(:name)       { should eq "rb_define_method" }
      its(:definition) { should eq "void rb_define_method(VALUE klass, const char *mid, VALUE (*func)(ANYARGS), int arity)" } # rubocop:disable Layout/LineLength
      its(:filepath)   { should be_end_with "/ruby/internal/method.h" }
      its(:typeref)    { should eq typedef(type: "void") }
      its(:args)       { should eq args }
    end

    context "rb_block_call" do
      subject { definitions.find { |d| d.name == "rb_block_call" } }

      let(:args) do
        [
          argument(type: "VALUE", name: "obj"),
          argument(type: "ID", name: "mid"),
          argument(type: "int", name: "argc"),
          argument(type: "VALUE", name: "argv", pointer: :ref),
          argument(type: "rb_block_call_func_t", name: "proc"),
          argument(type: "VALUE", name: "data2"),
        ]
      end

      its(:name)       { should eq "rb_block_call" }
      its(:definition) { should eq "VALUE rb_block_call(VALUE obj, ID mid, int argc, const VALUE *argv, rb_block_call_func_t proc, VALUE data2)" } # rubocop:disable Layout/LineLength
      its(:filepath)   { should be_end_with "/ruby/internal/iterator.h" }
      its(:typeref)    { should eq typedef(type: "VALUE") }
      its(:args)       { should eq args }
    end

    context "rb_thread_call_with_gvl" do
      subject { definitions.find { |d| d.name == "rb_thread_call_with_gvl" } }

      let(:args) do
        [
          argument(type: "void", name: "arg1", pointer: :ref),
          argument(type: "void", name: "data1", pointer: :ref),
        ]
      end

      its(:name)       { should eq "rb_thread_call_with_gvl" }
      its(:definition) { should eq "void *rb_thread_call_with_gvl(void *(*func)(void *), void *data1)" }
      its(:filepath)   { should be_end_with "/ruby/thread.h" }
      its(:typeref)    { should eq typedef(type: "void", pointer: :ref) }
      its(:args)       { should eq args }
    end

    context "rb_tracepoint_new" do
      subject { definitions.find { |d| d.name == "rb_tracepoint_new" } }

      let(:args) do
        [
          argument(type: "VALUE", name: "target_thread_not_supported_yet"),
          argument(type: "rb_event_flag_t", name: "events"),
          argument(type: "void", name: "arg3", pointer: :ref),
          argument(type: "void", name: "data", pointer: :ref),
        ]
      end

      its(:name)       { should eq "rb_tracepoint_new" }
      its(:definition) { should eq "VALUE rb_tracepoint_new(VALUE target_thread_not_supported_yet, rb_event_flag_t events, void (*func)(VALUE, void *), void *data)" } # rubocop:disable Layout/LineLength
      its(:filepath)   { should be_end_with "/ruby/debug.h" }
      its(:typeref)    { should eq typedef(type: "VALUE") }
      its(:args)       { should eq args }
    end

    context "rb_uv_to_utf8" do
      subject { definitions.find { |d| d.name == "rb_uv_to_utf8" } }

      let(:args) do
        [
          argument(type: "char", name: "buf", pointer: :array, length: 6),
          argument(type: "unsigned long", name: "uv"),
        ]
      end

      its(:name)       { should eq "rb_uv_to_utf8" }
      its(:definition) { should eq "int rb_uv_to_utf8(char buf[6], unsigned long uv)" }
      its(:filepath)   { should be_end_with "/ruby/internal/intern/bignum.h" }
      its(:typeref)    { should eq typedef(type: "int") }
      its(:args)       { should eq args }
    end

    context "rb_funcallv" do
      subject { definitions.find { |d| d.name == "rb_funcallv" } }

      let(:args) do
        [
          argument(type: "VALUE", name: "recv"),
          argument(type: "ID", name: "mid"),
          argument(type: "int", name: "argc"),
          argument(type: "VALUE", name: "argv", pointer: :array),
        ]
      end

      its(:name)       { should eq "rb_funcallv" }
      its(:definition) { should eq "VALUE rb_funcallv(VALUE recv, ID mid, int argc, const VALUE *argv)" }
      its(:filepath)   { should be_end_with "/ruby/internal/eval.h" }
      its(:typeref)    { should eq typedef(type: "VALUE") }
      its(:args)       { should eq args }
    end

    context "rb_find_file_ext" do
      subject { definitions.find { |d| d.name == "rb_find_file_ext" } }

      let(:args) do
        [
          argument(type: "VALUE", name: "feature", pointer: :ref),
          argument(type: "char", name: "exts", pointer: :ref),
        ]
      end

      its(:name)       { should eq "rb_find_file_ext" }
      its(:definition) { should eq "int rb_find_file_ext(VALUE *feature, const char *const *exts)" }
      its(:filepath)   { should be_end_with "/ruby/internal/intern/file.h" }
      its(:typeref)    { should eq typedef(type: "int") }
      its(:args)       { should eq args }
    end

    context "rb_errno_ptr" do
      subject { definitions.find { |d| d.name == "rb_errno_ptr" } }

      let(:args) do
        []
      end

      its(:name)       { should eq "rb_errno_ptr" }
      its(:definition) { should eq "int *rb_errno_ptr(void)" }
      its(:filepath)   { should be_end_with "/ruby/ruby.h" }
      its(:typeref)    { should eq typedef(type: "int", pointer: :ref) }
      its(:args)       { should eq args }
    end
  end

  describe "#extract_static_inline_function_definitions" do
    subject(:definitions) { parser.extract_static_inline_function_definitions }

    its(:count) { should be > 0 }

    it "should not return type defined in typedef" do
      definition_names = definitions.map(&:name)
      expect(definition_names).not_to include("rb_event_flag_t")
    end

    context "rb_num2int_inline" do
      subject { definitions.find { |d| d.name == "rb_num2int_inline" } }

      let(:args) do
        [
          argument(type: "VALUE", name: "x"),
        ]
      end

      its(:name)       { should eq "rb_num2int_inline" }
      its(:definition) { should eq "rb_num2int_inline(VALUE x)" }
      its(:filepath)   { should be_end_with "/ruby/internal/arithmetic/int.h" }
      its(:typeref)    { should eq typedef(type: "int") }
      its(:args)       { should eq args }
    end

    context "rb_int2num_inline" do
      subject { definitions.find { |d| d.name == "rb_int2num_inline" } }

      let(:args) do
        [
          argument(type: "int", name: "v"),
        ]
      end

      its(:name)       { should eq "rb_int2num_inline" }
      its(:definition) { should eq "rb_int2num_inline(int v)" }
      its(:filepath)   { should be_end_with "/ruby/internal/arithmetic/int.h" }
      its(:typeref)    { should eq typedef(type: "VALUE") }
      its(:args)       { should eq args }
    end
  end

  describe "#extract_struct_definitions" do
    subject(:definitions) { parser.extract_struct_definitions }

    its(:count) { should be > 0 }

    context "rb_data_type_struct" do
      subject { definitions.find { |d| d.name == "rb_data_type_struct" } }

      its(:name)     { should eq "rb_data_type_struct" }
      its(:filepath) { should be_end_with "/ruby/internal/core/rtypeddata.h" }
    end
  end

  describe "#extract_type_definitions" do
    subject(:definitions) { parser.extract_type_definitions }

    its(:count) { should be > 0 }

    context "rb_data_type_struct" do
      subject { definitions.find { |d| d.name == "VALUE" } }

      its(:name)     { should eq "VALUE" }
      its(:filepath) { should be_end_with "/ruby/internal/value.h" }
    end
  end
end
