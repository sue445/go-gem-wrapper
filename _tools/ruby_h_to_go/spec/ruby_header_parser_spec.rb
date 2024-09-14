RSpec.describe RubyHeaderParser do
  let(:parser) { RubyHeaderParser.new(RbConfig::CONFIG["rubyhdrdir"]) }

  describe "#extract_function_definitions" do
    subject(:definitions) { parser.extract_function_definitions }

    its(:count) { should be > 0 }

    context "rb_define_method" do
      subject { definitions.find { |d| d.name == "rb_define_method" } }

      let(:args) do
        [
          ArgumentDefinition.new(type: "VALUE", name: "klass"),
          ArgumentDefinition.new(type: "char", name: "mid", pointer: :ref),
          ArgumentDefinition.new(type: "void", name: "arg3", pointer: :ref),
          ArgumentDefinition.new(type: "int", name: "arity"),
        ]
      end

      its(:name)       { should eq "rb_define_method" }
      its(:definition) { should eq "void rb_define_method(VALUE klass, const char *mid, VALUE (*func)(ANYARGS), int arity)" }
      its(:filepath)   { should be_end_with "/ruby/internal/method.h" }
      its(:typeref)    { should eq TyperefDefinition.new(type: "void") }
      its(:args)       { should eq args }
    end

    context "rb_block_call" do
      subject { definitions.find { |d| d.name == "rb_block_call" } }

      let(:args) do
        [
          ArgumentDefinition.new(type: "VALUE", name: "obj"),
          ArgumentDefinition.new(type: "ID", name: "mid"),
          ArgumentDefinition.new(type: "int", name: "argc"),
          ArgumentDefinition.new(type: "VALUE", name: "argv", pointer: :ref),
          ArgumentDefinition.new(type: "rb_block_call_func_t", name: "proc"),
          ArgumentDefinition.new(type: "VALUE", name: "data2"),
        ]
      end

      its(:name)       { should eq "rb_block_call" }
      its(:definition) { should eq "VALUE rb_block_call(VALUE obj, ID mid, int argc, const VALUE *argv, rb_block_call_func_t proc, VALUE data2)" }
      its(:filepath)   { should be_end_with "/ruby/internal/iterator.h" }
      its(:typeref)    { should eq TyperefDefinition.new(type: "VALUE") }
      its(:args)       { should eq args }
    end

    context "rb_thread_call_with_gvl" do
      subject { definitions.find { |d| d.name == "rb_thread_call_with_gvl" } }

      let(:args) do
        [
          ArgumentDefinition.new(type: "void", name: "arg1", pointer: :ref),
          ArgumentDefinition.new(type: "void", name: "data1", pointer: :ref),
        ]
      end

      its(:name)       { should eq "rb_thread_call_with_gvl" }
      its(:definition) { should eq "void *rb_thread_call_with_gvl(void *(*func)(void *), void *data1)" }
      its(:filepath)   { should be_end_with "/ruby/thread.h" }
      its(:typeref)    { should eq TyperefDefinition.new(type: "void", pointer: :ref) }
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
