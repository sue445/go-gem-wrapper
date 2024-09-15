# frozen_string_literal: true

module Example
  class TestsTest < Test::Unit::TestCase
    include TestUtils

    test "#rb_ivar_get" do
      t = Example::Tests.new(2)
      assert { t.rb_ivar_get == 2 }
    end

    test "#rb_ivar_set" do
      t = Example::Tests.new
      t.rb_ivar_set(10)
      assert { t.ivar == 10 }
    end

    test ".rb_yield" do
      assert { Example::Tests.rb_yield(2) { |a| a * 3 } == 6 }
      assert_raise(ArgumentError) { Example::Tests.rb_yield(2) }
    end

    test ".rb_block_proc with block" do
      assert { Example::Tests.rb_block_proc(2) { |a| a * 3 } == 6 }
      assert_raise(ArgumentError) { Example::Tests.rb_block_proc(2) }
    end

    test ".rb_funcall2" do
      assert { Example::Tests.rb_funcall2(15, -1) == 20 }
    end

    test ".rb_funcall3" do
      assert { Example::Tests.rb_funcall3(15, -1) == 20 }
    end

    test ".rb_alias" do
      Example::Tests.rb_alias("rb_ivar_get_alias", "rb_ivar_get")
      t = Example::Tests.new
      assert { t.respond_to?(:rb_ivar_get_alias) }
    ensure
      Example::Tests.class_eval do
        remove_method :rb_ivar_get_alias if method_defined?(:rb_ivar_get_alias)
      end
    end

    test ".rb_class2name" do
      assert { Example::Tests.rb_class2name == "Example::Tests" }
    end

    class RbAttrTest < Test::Unit::TestCase
      teardown do
        Example::Tests.class_eval do
          remove_method :ivar2 if method_defined?(:ivar2)
          remove_method :ivar2= if method_defined?(:ivar2=)
        end
      end

      test "attr_reader" do
        Example::Tests.rb_attr("ivar2", 1, 0, 0)
        t = Example::Tests.new
        assert { t.respond_to?(:ivar2) }
        assert { !t.respond_to?(:ivar2=) }
      end

      test "attr_writer" do
        Example::Tests.rb_attr("ivar2", 0, 1, 0)
        t = Example::Tests.new
        assert { !t.respond_to?(:ivar2) }
        assert { t.respond_to?(:ivar2=) }
      end

      test "attr_accessor" do
        Example::Tests.rb_attr("ivar2", 1, 1, 0)
        t = Example::Tests.new
        assert { t.respond_to?(:ivar2) }
        assert { t.respond_to?(:ivar2=) }
      end
    end

    test ".rb_const_get" do
      assert { Example::Tests.rb_const_get("CONST") == "TEST" }
    end

    test ".rb_const_get_at" do
      assert { Example::Tests.rb_const_get_at("CONST") == "TEST" }
    end

    test ".rb_const_set" do
      silence_warning do
        Example::Tests.rb_const_set("CONST", "NEW")
      end

      assert { Example::Tests::CONST == "NEW" }
    ensure
      silence_warning do
        Example::Tests::CONST = "TEST"
      end
    end

    test ".rb_const_defined" do
      assert { Example::Tests.rb_const_defined("CONST") }
      assert { !Example::Tests.rb_const_defined("THIS_IS_NOT_DEFINED") }
    end

    test ".rb_const_defined_at" do
      assert { Example::Tests.rb_const_defined_at("CONST") }
      assert { !Example::Tests.rb_const_defined_at("THIS_IS_NOT_DEFINED") }
    end

    test ".rb_eval_string" do
      assert { Example::Tests.rb_eval_string("1 + 2") == 3 }
    end

    test ".rb_eval_string_protect" do
      ret, state = Example::Tests.rb_eval_string_protect("1 + 2")
      assert { ret == 3 }
      assert { state == 0 }
    end

    test ".rb_eval_string_wrap" do
      ret, state = Example::Tests.rb_eval_string_wrap("1 + 2")
      assert { ret == 3 }
      assert { state == 0 }
    end

    test ".rb_ary_new" do
      assert { Example::Tests.rb_ary_new == [] }
    end

    test ".rb_ary_new_capa" do
      assert { Example::Tests.rb_ary_new_capa(1) == [] }
    end

    test ".rb_ary_push" do
      array = [1]
      ret = Example::Tests.rb_ary_push(array, 2)
      assert { array == [1, 2] }
      assert { ret == [1, 2] }
    end

    test ".rb_ary_pop" do
      array = [1, 2]
      ret = Example::Tests.rb_ary_pop(array)
      assert { array == [1] }
      assert { ret == 2 }
    end

    test ".rb_ary_shift" do
      array = [1, 2]
      ret = Example::Tests.rb_ary_shift(array)
      assert { array == [2] }
      assert { ret == 1 }
    end

    test ".rb_ary_unshift" do
      array = [1]
      ret = Example::Tests.rb_ary_unshift(array, 2)
      assert { array == [2, 1] }
      assert { ret == [2, 1] }
    end

    test "#nop_rb_define_method_id" do
      assert { Example::Tests.new.respond_to?(:nop_rb_define_method_id) }
    end

    test "#nop_rb_define_private_method" do
      assert { Example::Tests.private_instance_methods(false).include?(:nop_rb_define_private_method) }
    end

    test "#nop_rb_define_protected_method" do
      assert { Example::Tests.protected_instance_methods(false).include?(:nop_rb_define_protected_method) }
    end

    # rubocop:disable Style/GlobalVars this is test for global variable
    test ".rb_define_variable" do
      Example::Tests.rb_define_variable("$global_var", 1)
      assert { $global_var == 1 }
    ensure
      $global_var = nil
    end
    # rubocop:enable Style/GlobalVars

    test ".rb_define_const" do
      Example::Tests.rb_define_const("RB_DEFINE_CONST", 1)
      assert { Example::Tests::RB_DEFINE_CONST == 1 }
    ensure
      Example::Tests.class_eval do
        remove_const(:RB_DEFINE_CONST) if const_defined?(:RB_DEFINE_CONST, false)
      end
    end
  end
end
