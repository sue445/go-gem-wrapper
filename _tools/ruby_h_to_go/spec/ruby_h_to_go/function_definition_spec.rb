# frozen_string_literal: true

RSpec.describe RubyHToGo::FunctionDefinition do
  describe "#generate_go_content" do
    subject { RubyHToGo::FunctionDefinition.new(definition:).generate_go_content }

    context "rb_define_method" do
      let(:definition) do
        RubyHeaderParser::FunctionDefinition.new(
          name:       "rb_define_method",
          definition: "void rb_define_method(VALUE klass, const char *mid, VALUE (*func)(ANYARGS), int arity)",
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

          C.rb_define_method(C.VALUE(klass), char, toCFunctionPointer(arg3), C.int(arity))
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

    context "rb_funcallv" do
      let(:definition) do
        RubyHeaderParser::FunctionDefinition.new(
          name:       "rb_funcallv",
          definition: "VALUE rb_funcallv(VALUE recv, ID mid, int argc, const VALUE *argv)",
          typeref:    typedef(type: "VALUE"),
          args:       [
            argument(type: "VALUE", name: "recv"),
            argument(type: "ID", name: "mid"),
            argument(type: "int", name: "argc"),
            argument(type: "VALUE", name: "argv", pointer: :array),
          ],
        )
      end

      let(:go_content) do
        <<~GO
          // RbFuncallv calls `rb_funcallv` in C
          //
          // Original definition is following
          //
          //	VALUE rb_funcallv(VALUE recv, ID mid, int argc, const VALUE *argv)
          func RbFuncallv(recv VALUE, mid ID, argc int, argv []VALUE) VALUE {
          ret := VALUE(C.rb_funcallv(C.VALUE(recv), C.ID(mid), C.int(argc), toCArray[VALUE, C.VALUE](argv)))
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
          ret := unsafe.Pointer(C.rb_thread_call_with_gvl(toCFunctionPointer(arg1), toCFunctionPointer(data1)))
          return ret
          }

        GO
      end

      it { should eq go_content }
    end

    context "rb_uv_to_utf8" do
      let(:definition) do
        RubyHeaderParser::FunctionDefinition.new(
          name:       "rb_uv_to_utf8",
          definition: "int rb_uv_to_utf8(char buf[6], unsigned long uv)",
          typeref:    typedef(type: "int"),
          args:       [
            argument(type: "char", name: "buf", pointer: :array, length: 6),
            argument(type: "unsigned long", name: "uv"),
          ],
        )
      end

      let(:go_content) do
        <<~GO
          // RbUvToUtf8 calls `rb_uv_to_utf8` in C
          //
          // Original definition is following
          //
          //	int rb_uv_to_utf8(char buf[6], unsigned long uv)
          func RbUvToUtf8(buf []Char, uv uint) int {
          ret := int(C.rb_uv_to_utf8(toCArray[Char, C.char](buf), C.ulong(uv)))
          return ret
          }

        GO
      end

      it { should eq go_content }
    end

    context "rb_errno_ptr" do
      let(:definition) do
        RubyHeaderParser::FunctionDefinition.new(
          name:       "rb_errno_ptr",
          definition: "int *rb_errno_ptr(void)",
          typeref:    typedef(type: "int", pointer: :ref),
          args:       [],
        )
      end

      let(:go_content) do
        <<~GO
          // RbErrnoPtr calls `rb_errno_ptr` in C
          //
          // Original definition is following
          //
          //	int *rb_errno_ptr(void)
          func RbErrnoPtr() *int {
          ret := (*int)(C.rb_errno_ptr())
          return ret
          }

        GO
      end

      it { should eq go_content }
    end

    context "rb_big2ll" do
      let(:definition) do
        RubyHeaderParser::FunctionDefinition.new(
          name:       "rb_big2ll",
          definition: "rb_big2ll(VALUE)",
          typeref:    typedef(type: "long long"),
          args:       [
            argument(type: "VALUE", name: "arg1"),
          ],
        )
      end

      let(:go_content) do
        <<~GO
          // RbBig2Ll calls `rb_big2ll` in C
          //
          // Original definition is following
          //
          //	rb_big2ll(VALUE)
          func RbBig2Ll(arg1 VALUE) Longlong {
          ret := Longlong(C.rb_big2ll(C.VALUE(arg1)))
          return ret
          }

        GO
      end

      it { should eq go_content }
    end

    context "rb_big2ull" do
      let(:definition) do
        RubyHeaderParser::FunctionDefinition.new(
          name:       "rb_big2ull",
          definition: "rb_big2ull(VALUE)",
          typeref:    typedef(type: "unsigned long long"),
          args:       [
            argument(type: "VALUE", name: "arg1"),
          ],
        )
      end

      let(:go_content) do
        <<~GO
          // RbBig2Ull calls `rb_big2ull` in C
          //
          // Original definition is following
          //
          //	rb_big2ull(VALUE)
          func RbBig2Ull(arg1 VALUE) Ulonglong {
          ret := Ulonglong(C.rb_big2ull(C.VALUE(arg1)))
          return ret
          }

        GO
      end

      it { should eq go_content }
    end

    context "rb_scan_args_set" do
      let(:definition) do
        RubyHeaderParser::FunctionDefinition.new(
          name:       "rb_scan_args_set",
          definition: "rb_scan_args_set(int kw_flag, int argc, const VALUE *argv,",
          typeref:    typedef(type: "int"),
          args:       [
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
          ],
        )
      end

      let(:go_content) do
        <<~GO
          // RbScanArgsSet calls `rb_scan_args_set` in C
          //
          // Original definition is following
          //
          //	rb_scan_args_set(int kw_flag, int argc, const VALUE *argv,
          func RbScanArgsSet(kw_flag int, argc int, argv *VALUE, n_lead int, n_opt int, n_trail int, f_var Bool, f_hash Bool, f_block Bool, vars []*VALUE, fmt string, varc int) int {
          char, clean := string2Char(fmt)
          defer clean()

          var cArgv C.VALUE
          ret := int(C.rb_scan_args_set(C.int(kw_flag), C.int(argc), &cArgv, C.int(n_lead), C.int(n_opt), C.int(n_trail), C._Bool(f_var), C._Bool(f_hash), C._Bool(f_block), toCArray[*VALUE, *C.VALUE](vars), char, C.int(varc)))
          *argv = VALUE(cArgv)
          return ret
          }

        GO
      end

      it { should eq go_content }
    end

    context "RSTRING_END" do
      let(:definition) do
        RubyHeaderParser::FunctionDefinition.new(
          name:       "RSTRING_END",
          definition: "RSTRING_END(VALUE str)",
          typeref:    typedef(type: "char", pointer: :ref),
          args:       [
            argument(type: "VALUE", name: "str"),
          ],
        )
      end

      let(:go_content) do
        <<~GO
          // RSTRING_END calls `RSTRING_END` in C
          //
          // Original definition is following
          //
          //	RSTRING_END(VALUE str)
          func RSTRING_END(str VALUE) string {
          ret := char2String(C.RSTRING_END(C.VALUE(str)))
          return ret
          }

        GO
      end

      it { should eq go_content }
    end
  end

  describe "#go_function_name" do
    subject { RubyHToGo::FunctionDefinition.new(definition:).go_function_name }

    let(:definition) do
      RubyHeaderParser::FunctionDefinition.new(
        name:,
        definition: "",
        typeref:    typedef(type: "void"),
        args:       [],
      )
    end

    using RSpec::Parameterized::TableSyntax

    where(:name, :expected) do
      "RB_FIX2INT" | "RB_FIX2INT"
      "rb_fix2int" | "RbFix2Int"
    end

    with_them do
      it { should eq expected }
    end
  end
end
