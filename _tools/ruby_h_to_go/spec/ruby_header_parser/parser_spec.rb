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
