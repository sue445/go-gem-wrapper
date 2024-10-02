# frozen_string_literal: true

RSpec.describe RubyHeaderParser::Parser do
  include_context "uses temp dir"

  let(:parser) { RubyHeaderParser::Parser.new(dist_preprocessed_header_file:) }
  let(:dist_preprocessed_header_file) { File.join(temp_dir, "ruby_preprocessed.h") }

  describe "#extract_function_definitions" do
    subject(:definitions) { parser.extract_function_definitions }

    its(:count) { should be > 0 }

    context "rb_define_method" do
      subject { definitions.find { |d| d.name == "rb_define_method" } }

      let(:args) do
        [
          argument(type: "VALUE", name: "klass"),
          argument(type: "char", name: "mid", pointer: :ref),
          argument(type: "void", name: "arg3", pointer: :function),
          argument(type: "int", name: "arity"),
        ]
      end

      its(:name)       { should eq "rb_define_method" }
      its(:definition) { should eq "void rb_define_method(VALUE klass, const char *mid, VALUE (*func)(), int arity)" }
      its(:typeref)    { should eq typeref(type: "void") }
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
      its(:typeref)    { should eq typeref(type: "VALUE") }
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
      its(:typeref)    { should eq typeref(type: "int") }
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
      its(:typeref)    { should eq typeref(type: "VALUE") }
      its(:args)       { should eq args }
    end

    context "rb_find_file_ext" do
      subject { definitions.find { |d| d.name == "rb_find_file_ext" } }

      let(:args) do
        [
          argument(type: "VALUE", name: "feature", pointer: :ref),
          argument(type: "char", name: "exts", pointer: :str_array),
        ]
      end

      its(:name)       { should eq "rb_find_file_ext" }
      its(:definition) { should eq "int rb_find_file_ext(VALUE *feature, const char *const *exts)" }
      its(:typeref)    { should eq typeref(type: "int") }
      its(:args)       { should eq args }
    end

    context "rb_errno_ptr" do
      subject { definitions.find { |d| d.name == "rb_errno_ptr" } }

      let(:args) do
        []
      end

      its(:name)       { should eq "rb_errno_ptr" }
      its(:definition) { should eq "int *rb_errno_ptr(void)" }
      its(:typeref)    { should eq typeref(type: "int", pointer: :ref) }
      its(:args)       { should eq args }
    end

    context "rb_block_proc" do
      subject { definitions.find { |d| d.name == "rb_block_proc" } }

      let(:args) do
        []
      end

      its(:name)       { should eq "rb_block_proc" }
      its(:definition) { should eq "VALUE rb_block_proc(void)" }
      its(:typeref)    { should eq typeref(type: "VALUE") }
      its(:args)       { should eq args }
    end

    context "rb_big2ll" do
      subject { definitions.find { |d| d.name == "rb_big2ll" } }

      let(:args) do
        [
          argument(type: "VALUE", name: "arg1"),
        ]
      end

      its(:name)       { should eq "rb_big2ll" }
      its(:definition) { should include "rb_big2ll(VALUE)" }
      its(:typeref)    { should eq typeref(type: "long long") }
      its(:args)       { should eq args }
    end

    context "rb_big2ull" do
      subject { definitions.find { |d| d.name == "rb_big2ull" } }

      let(:args) do
        [
          argument(type: "VALUE", name: "arg1"),
        ]
      end

      its(:name)       { should eq "rb_big2ull" }
      its(:definition) { should include "rb_big2ull(VALUE)" }
      its(:typeref)    { should eq typeref(type: "unsigned long long") }
      its(:args)       { should eq args }
    end

    context "rb_const_list" do
      subject { definitions.find { |d| d.name == "rb_const_list" } }

      let(:args) do
        [
          argument(type: "void", name: "arg1", pointer: :ref),
        ]
      end

      its(:name)       { should eq "rb_const_list" }
      its(:definition) { should eq "VALUE rb_const_list(void*)" }
      its(:typeref)    { should eq typeref(type: "VALUE") }
      its(:args)       { should eq args }
    end

    context "rb_feature_provided" do
      subject { definitions.find { |d| d.name == "rb_feature_provided" } }

      let(:args) do
        [
          argument(type: "char", name: "feature", pointer: :ref),
          argument(type: "char", name: "loading", pointer: :sref, length: 2),
        ]
      end

      its(:name)       { should eq "rb_feature_provided" }
      its(:definition) { should eq "int rb_feature_provided(const char *feature, const char **loading)" }
      its(:typeref)    { should eq typeref(type: "int") }
      its(:args)       { should eq args }
    end

    context "rb_define_variable" do
      subject { definitions.find { |d| d.name == "rb_define_variable" } }

      let(:args) do
        [
          argument(type: "char", name: "name", pointer: :ref),
          argument(type: "VALUE", name: "var", pointer: :in_ref),
        ]
      end

      its(:name)       { should eq "rb_define_variable" }
      its(:definition) { should eq "void rb_define_variable(const char *name, VALUE *var)" }
      its(:typeref)    { should eq typeref(type: "void") }
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
      its(:typeref)    { should eq typeref(type: "int") }
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
      its(:typeref)    { should eq typeref(type: "VALUE") }
      its(:args)       { should eq args }
    end

    context "rb_scan_args_set" do
      subject { definitions.find { |d| d.name == "rb_scan_args_set" } }

      let(:args) do
        [
          argument(type: "int", name: "kw_flag"),
          argument(type: "int", name: "argc"),
          argument(type: "VALUE", name: "argv", pointer: :ref),
          argument(type: "int", name: "n_lead"),
          argument(type: "int", name: "n_opt"),
          argument(type: "int", name: "n_trail"),
          argument(type: "_Bool", name: "f_var"),
          argument(type: "_Bool", name: "f_hash"),
          argument(type: "_Bool", name: "f_block"),
          argument(type: "VALUE", name: "vars", pointer: :ref_array),
          argument(type: "char", name: "fmt", pointer: :ref),
          argument(type: "int", name: "varc"),
        ]
      end

      its(:name)       { should eq "rb_scan_args_set" }
      its(:definition) { should eq "rb_scan_args_set(int kw_flag, int argc, const VALUE *argv," } # TODO: Fix this after
      its(:typeref)    { should eq typeref(type: "int") }
      its(:args)       { should eq args }
    end

    context "RSTRING_END" do
      subject { definitions.find { |d| d.name == "RSTRING_END" } }

      let(:args) do
        [
          argument(type: "VALUE", name: "str"),
        ]
      end

      its(:name)       { should eq "RSTRING_END" }
      its(:definition) { should eq "RSTRING_END(VALUE str)" }
      its(:typeref)    { should eq typeref(type: "char", pointer: :ref) }
      its(:args)       { should eq args }
    end

    context "rb_data_typed_object_make" do
      subject { definitions.find { |d| d.name == "rb_data_typed_object_make" } }

      let(:args) do
        [
          argument(type: "VALUE", name: "klass"),
          argument(type: "rb_data_type_t", name: "type", pointer: :ref),
          argument(type: "void", name: "datap", pointer: :sref, length: 2),
          argument(type: "size_t", name: "size"),
        ]
      end

      its(:name)       { should eq "rb_data_typed_object_make" }
      its(:definition) { should eq "rb_data_typed_object_make(VALUE klass, const rb_data_type_t *type, void **datap, size_t size)" } # rubocop:disable Layout/LineLength
      its(:typeref)    { should eq typeref(type: "VALUE") }
      its(:args)       { should eq args }
    end

    context "RSTRING_PTR" do
      subject { definitions.find { |d| d.name == "RSTRING_PTR" } }

      let(:args) do
        [
          argument(type: "VALUE", name: "str"),
        ]
      end

      its(:name)       { should eq "RSTRING_PTR" }
      its(:definition) { should eq "RSTRING_PTR(VALUE str)" }
      its(:typeref)    { should eq typeref(type: "char", pointer: :raw) }
      its(:args)       { should eq args }
    end
  end

  describe "#extract_struct_definitions" do
    subject(:definitions) { parser.extract_struct_definitions }

    its(:count) { should eq 0 }
  end

  describe "#extract_type_definitions" do
    subject(:definitions) { parser.extract_type_definitions }

    its(:count) { should be > 0 }

    context "rb_data_type_struct" do
      subject { definitions.find { |d| d.name == "VALUE" } }

      its(:name) { should eq "VALUE" }
    end
  end

  describe "#extract_enum_definitions" do
    subject(:definitions) { parser.extract_enum_definitions }

    its(:count) { should be > 0 }

    context "ruby_value_type" do
      subject { definitions.find { |d| d.name == "ruby_value_type" } }

      its(:name) { should eq "ruby_value_type" }
      its(:values) { should include "RUBY_T_ARRAY" }
    end
  end
end
