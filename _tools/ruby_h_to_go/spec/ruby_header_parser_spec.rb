RSpec.describe RubyHeaderParser do
  let(:parser) { RubyHeaderParser.new(RbConfig::CONFIG["rubyhdrdir"]) }

  describe "#extract_function_definitions" do
    subject(:definitions) { parser.extract_function_definitions }

    its(:count) { should be > 0 }

    context "rb_define_method" do
      subject { definitions.find { |d| d[:function_name] == "rb_define_method" } }

      its([:function_name])   { should eq "rb_define_method" }
      its([:definition])      { should eq "void rb_define_method(VALUE klass, const char *mid, VALUE (*func)(ANYARGS), int arity)" }
      its([:filepath])        { should be_end_with "/ruby/internal/method.h" }
      its([:typeref])         { should eq "void" }
      its([:typeref_pointer]) { should eq nil }
      its([:args])            { should eq [{ name: "klass", pointer: nil, type: "VALUE" }, { name: "mid", pointer: :ref, type: "char" }, { name: "arg3", pointer: :ref, type: "void" }, { name: "arity", pointer: nil, type: "int" }] }
    end

    context "rb_block_call" do
      subject { definitions.find { |d| d[:function_name] == "rb_block_call" } }

      its([:function_name])   { should eq "rb_block_call" }
      its([:definition])      { should eq "VALUE rb_block_call(VALUE obj, ID mid, int argc, const VALUE *argv, rb_block_call_func_t proc, VALUE data2)" }
      its([:filepath])        { should be_end_with "/ruby/internal/iterator.h" }
      its([:typeref])         { should eq "VALUE" }
      its([:typeref_pointer]) { should eq nil }
      its([:args])            { should eq [{ name: "obj", pointer: nil, type: "VALUE" }, { name: "mid", pointer: nil, type: "ID" }, { name: "argc", pointer: nil, type: "int" }, { name: "argv", pointer: :ref, type: "VALUE" }, { name: "proc", pointer: nil, type: "rb_block_call_func_t" }, { name: "data2", pointer: nil, type: "VALUE" }] }
    end

    context "rb_thread_call_with_gvl" do
      subject { definitions.find { |d| d[:function_name] == "rb_thread_call_with_gvl" } }

      its([:function_name])   { should eq "rb_thread_call_with_gvl" }
      its([:definition])      { should eq "void *rb_thread_call_with_gvl(void *(*func)(void *), void *data1)" }
      its([:filepath])        { should be_end_with "/ruby/thread.h" }
      its([:typeref])         { should eq "void" }
      its([:typeref_pointer]) { should eq :ref }
      its([:args])            { should eq [{:name=>"arg1", :pointer=>:ref, :type=>"void"}, {:name=>"data1", :pointer=>:ref, :type=>"void"}] }
    end
  end

  describe "#extract_struct_definitions" do
    subject(:definitions) { parser.extract_struct_definitions }

    its(:count) { should be > 0 }

    context "rb_data_type_struct" do
      subject { definitions.find { |d| d[:struct_name] == "rb_data_type_struct" } }

      its([:struct_name]) { should eq "rb_data_type_struct" }
      its([:filepath])    { should be_end_with "/ruby/internal/core/rtypeddata.h" }
    end
  end

  describe "#extract_type_definitions" do
    subject(:definitions) { parser.extract_type_definitions }

    its(:count) { should be > 0 }

    context "rb_data_type_struct" do
      subject { definitions.find { |d| d[:type_name] == "VALUE" } }

      its([:type_name]) { should eq "VALUE" }
      its([:filepath])  { should be_end_with "/ruby/internal/value.h" }
    end
  end
end
