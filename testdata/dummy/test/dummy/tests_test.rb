# frozen_string_literal: true

module Dummy
  class TestsTest < Test::Unit::TestCase # rubocop:disable Metrics/ClassLength
    include TestUtils

    test "#rb_ivar_get" do
      t = Dummy::Tests.new(2)
      assert { t.rb_ivar_get == 2 }
    end

    test "#rb_ivar_set" do
      t = Dummy::Tests.new
      t.rb_ivar_set(10)
      assert { t.ivar == 10 }
    end

    test ".rb_yield" do
      assert { Dummy::Tests.rb_yield(2) { |a| a * 3 } == 6 }
      assert_raise(ArgumentError) { Dummy::Tests.rb_yield(2) }
    end

    test ".rb_block_proc with block" do
      assert { Dummy::Tests.rb_block_proc(2) { |a| a * 3 } == 6 }
      assert_raise(ArgumentError) { Dummy::Tests.rb_block_proc(2) }
    end

    test ".rb_funcall2" do
      assert { Dummy::Tests.rb_funcall2(15, -1) == 20 }
    end

    test ".rb_funcall3" do
      assert { Dummy::Tests.rb_funcall3(15, -1) == 20 }
    end

    test ".rb_alias" do
      Dummy::Tests.rb_alias("rb_ivar_get_alias", "rb_ivar_get")
      t = Dummy::Tests.new
      assert { t.respond_to?(:rb_ivar_get_alias) }
    ensure
      Dummy::Tests.class_eval do
        remove_method :rb_ivar_get_alias if method_defined?(:rb_ivar_get_alias)
      end
    end

    test ".rb_class2name" do
      assert { Dummy::Tests.rb_class2name == "Dummy::Tests" }
    end

    class RbAttrTest < Test::Unit::TestCase
      teardown do
        Dummy::Tests.class_eval do
          remove_method :ivar2 if method_defined?(:ivar2)
          remove_method :ivar2= if method_defined?(:ivar2=)
        end
      end

      test "attr_reader" do
        Dummy::Tests.rb_attr("ivar2", 1, 0, 0)
        t = Dummy::Tests.new
        assert { t.respond_to?(:ivar2) }
        assert { !t.respond_to?(:ivar2=) }
      end

      test "attr_writer" do
        Dummy::Tests.rb_attr("ivar2", 0, 1, 0)
        t = Dummy::Tests.new
        assert { !t.respond_to?(:ivar2) }
        assert { t.respond_to?(:ivar2=) }
      end

      test "attr_accessor" do
        Dummy::Tests.rb_attr("ivar2", 1, 1, 0)
        t = Dummy::Tests.new
        assert { t.respond_to?(:ivar2) }
        assert { t.respond_to?(:ivar2=) }
      end
    end

    test ".rb_const_get" do
      assert { Dummy::Tests.rb_const_get("CONST") == "TEST" }
    end

    test ".rb_const_get_at" do
      assert { Dummy::Tests.rb_const_get_at("CONST") == "TEST" }
    end

    test ".rb_const_set" do
      silence_warning do
        Dummy::Tests.rb_const_set("CONST", "NEW")
      end

      assert { Dummy::Tests::CONST == "NEW" }
    ensure
      silence_warning do
        Dummy::Tests::CONST = "TEST"
      end
    end

    test ".rb_const_defined" do
      assert { Dummy::Tests.rb_const_defined("CONST") }
      assert { !Dummy::Tests.rb_const_defined("THIS_IS_NOT_DEFINED") }
    end

    test ".rb_const_defined_at" do
      assert { Dummy::Tests.rb_const_defined_at("CONST") }
      assert { !Dummy::Tests.rb_const_defined_at("THIS_IS_NOT_DEFINED") }
    end

    test ".rb_eval_string" do
      assert { Dummy::Tests.rb_eval_string("1 + 2") == 3 }
    end

    test ".rb_eval_string_protect" do
      ret, state = Dummy::Tests.rb_eval_string_protect("1 + 2")
      assert { ret == 3 }
      assert { state == 0 }
    end

    test ".rb_eval_string_wrap" do
      ret, state = Dummy::Tests.rb_eval_string_wrap("1 + 2")
      assert { ret == 3 }
      assert { state == 0 }
    end

    test ".rb_ary_new" do
      assert { Dummy::Tests.rb_ary_new == [] }
    end

    test ".rb_ary_new_capa" do
      assert { Dummy::Tests.rb_ary_new_capa(1) == [] }
    end

    test ".rb_ary_push" do
      array = [1]
      ret = Dummy::Tests.rb_ary_push(array, 2)
      assert { array == [1, 2] }
      assert { ret == [1, 2] }
    end

    test ".rb_ary_pop" do
      array = [1, 2]
      ret = Dummy::Tests.rb_ary_pop(array)
      assert { array == [1] }
      assert { ret == 2 }
    end

    test ".rb_ary_shift" do
      array = [1, 2]
      ret = Dummy::Tests.rb_ary_shift(array)
      assert { array == [2] }
      assert { ret == 1 }
    end

    test ".rb_ary_unshift" do
      array = [1]
      ret = Dummy::Tests.rb_ary_unshift(array, 2)
      assert { array == [2, 1] }
      assert { ret == [2, 1] }
    end
  end
end
