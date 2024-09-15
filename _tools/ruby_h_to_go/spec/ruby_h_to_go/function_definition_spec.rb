# frozen_string_literal: true

RSpec.describe RubyHToGo::FunctionDefinition do
  describe "#generate_go_content" do
    subject { RubyHToGo::FunctionDefinition.new(definition).generate_go_content }

    context "rb_define_method" do
      let(:definition) do
        RubyHeaderParser::FunctionDefinition.new(
          name:       "rb_define_method",
          definition: "void rb_define_method(VALUE klass, const char *mid, VALUE (*func)(ANYARGS), int arity)",
          filepath:   "/path/to/include/ruby/internal/method.h",
          typeref:    typedef(type: "void"),
          args:       [
            argument(type: "VALUE", name: "klass"),
            argument(type: "char", name: "mid", pointer: :ref),
            argument(type: "void", name: "arg3", pointer: :ref),
            argument(type: "int", name: "arity"),
          ],
        )
      end

      let(:go_content) do
        <<~GO
          // RbDefineMethod calls `rb_define_method` in C
          //
          // Original definition is following
          //
          //	void rb_define_method(VALUE klass, const char *mid, VALUE (*func)(ANYARGS), int arity)
          func RbDefineMethod(klass VALUE, mid string, arg3 unsafe.Pointer, arity int)  {
          char, clean := string2Char(mid)
          defer clean()

          C.rb_define_method(C.VALUE(klass), char, toCPointer(arg3), C.int(arity))
          }

        GO
      end

      it { should eq go_content }
    end

    context "rb_block_call" do
      let(:definition) do
        RubyHeaderParser::FunctionDefinition.new(
          name:       "rb_block_call",
          definition: "VALUE rb_block_call(VALUE obj, ID mid, int argc, const VALUE *argv, rb_block_call_func_t proc, VALUE data2)", # rubocop:disable Layout/LineLength
          filepath:   "/path/to/include/ruby/internal/iterator.h",
          typeref:    typedef(type: "VALUE"),
          args:       [
            argument(type: "VALUE", name: "obj"),
            argument(type: "ID", name: "mid"),
            argument(type: "int", name: "argc"),
            argument(type: "VALUE", name: "argv", pointer: :ref),
            argument(type: "rb_block_call_func_t", name: "proc"),
            argument(type: "VALUE", name: "data2"),
          ],
        )
      end

      let(:go_content) do
        <<~GO
          // RbBlockCall calls `rb_block_call` in C
          //
          // Original definition is following
          //
          //	VALUE rb_block_call(VALUE obj, ID mid, int argc, const VALUE *argv, rb_block_call_func_t proc, VALUE data2)
          func RbBlockCall(obj VALUE, mid ID, argc int, argv *VALUE, proc RbBlockCallFuncT, data2 VALUE) VALUE {
          var cArgv C.VALUE
          ret := VALUE(C.rb_block_call(C.VALUE(obj), C.ID(mid), C.int(argc), &cArgv, C.rb_block_call_func_t(proc), C.VALUE(data2)))
          *argv = VALUE(cArgv)
          return ret
          }

        GO
      end

      it { should eq go_content }
    end

    context "rb_thread_call_with_gvl" do
      let(:definition) do
        RubyHeaderParser::FunctionDefinition.new(
          name:       "rb_thread_call_with_gvl",
          definition: "void *rb_thread_call_with_gvl(void *(*func)(void *), void *data1)",
          filepath:   "/path/to/include/rubythread.h",
          typeref:    typedef(type: "void", pointer: :ref),
          args:       [
            argument(type: "void", name: "arg1", pointer: :ref),
            argument(type: "void", name: "data1", pointer: :ref),
          ],
        )
      end

      let(:go_content) do
        <<~GO
          // RbThreadCallWithGvl calls `rb_thread_call_with_gvl` in C
          //
          // Original definition is following
          //
          //	void *rb_thread_call_with_gvl(void *(*func)(void *), void *data1)
          func RbThreadCallWithGvl(arg1 unsafe.Pointer, data1 unsafe.Pointer) unsafe.Pointer {
          ret := unsafe.Pointer(C.rb_thread_call_with_gvl(toCPointer(arg1), toCPointer(data1)))
          return ret
          }

        GO
      end

      it { should eq go_content }
    end
  end
end
