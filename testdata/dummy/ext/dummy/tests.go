package main

/*
#include "dummy.h"

VALUE rb_dummy_tests_rb_ivar_get(VALUE self);
void  rb_dummy_tests_rb_ivar_set(VALUE self, VALUE value);
VALUE rb_dummy_tests_rb_yield(VALUE self, VALUE arg);
VALUE rb_dummy_tests_rb_block_proc(VALUE self, VALUE arg);
VALUE rb_dummy_tests_rb_funcall2(VALUE self, VALUE num, VALUE ndigits);
VALUE rb_dummy_tests_rb_funcall3(VALUE self, VALUE num, VALUE ndigits);
void  rb_dummy_tests_rb_alias(VALUE self, VALUE dst, VALUE src);
VALUE rb_dummy_tests_rb_class2name(VALUE self);
void  rb_dummy_tests_rb_attr(VALUE self, VALUE name, VALUE needReader, VALUE needWriter, VALUE honourVisibility);
VALUE rb_dummy_tests_rb_const_get(VALUE self, VALUE name);
VALUE rb_dummy_tests_rb_const_get_at(VALUE self, VALUE name);
void  rb_dummy_tests_rb_const_set(VALUE self, VALUE name, VALUE val);
VALUE rb_dummy_tests_rb_const_defined(VALUE self, VALUE name);
VALUE rb_dummy_tests_rb_const_defined_at(VALUE self, VALUE name);
VALUE rb_dummy_tests_rb_eval_string(VALUE self, VALUE str);
*/
import "C"

import (
	ruby "github.com/sue445/go-gem-wrapper"
)

//export rb_dummy_tests_rb_ivar_get
func rb_dummy_tests_rb_ivar_get(self C.VALUE) C.VALUE {
	ivarID := ruby.RbIntern("@ivar")
	ivarValue := ruby.RbIvarGet(ruby.VALUE(self), ivarID)

	return C.VALUE(ivarValue)
}

//export rb_dummy_tests_rb_ivar_set
func rb_dummy_tests_rb_ivar_set(self C.VALUE, value C.VALUE) {
	ivarID := ruby.RbIntern("@ivar")
	ruby.RbIvarSet(ruby.VALUE(self), ivarID, ruby.VALUE(value))
}

//export rb_dummy_tests_rb_yield
func rb_dummy_tests_rb_yield(_ C.VALUE, arg C.VALUE) C.VALUE {
	if !ruby.RbBlockGivenP() {
		ruby.RbRaise(ruby.VALUE(C.rb_eArgError), "Block not given")
	}

	blockResult := ruby.RbYield(ruby.VALUE(arg))
	return C.VALUE(blockResult)
}

//export rb_dummy_tests_rb_block_proc
func rb_dummy_tests_rb_block_proc(_ C.VALUE, arg C.VALUE) C.VALUE {
	if !ruby.RbBlockGivenP() {
		ruby.RbRaise(ruby.VALUE(C.rb_eArgError), "Block not given")
	}

	block := ruby.RbBlockProc()

	// Call Proc#call
	blockResult := ruby.RbFuncall2(ruby.VALUE(block), ruby.RbIntern("call"), 1, []ruby.VALUE{ruby.VALUE(arg)})

	return C.VALUE(blockResult)
}

//export rb_dummy_tests_rb_funcall2
func rb_dummy_tests_rb_funcall2(_ C.VALUE, num C.VALUE, ndigits C.VALUE) C.VALUE {
	// Call Integer#round
	result := ruby.RbFuncall2(ruby.VALUE(num), ruby.RbIntern("round"), 1, []ruby.VALUE{ruby.VALUE(ndigits)})

	return C.VALUE(result)
}

//export rb_dummy_tests_rb_funcall3
func rb_dummy_tests_rb_funcall3(_ C.VALUE, num C.VALUE, ndigits C.VALUE) C.VALUE {
	// Call Integer#round
	result := ruby.RbFuncall3(ruby.VALUE(num), ruby.RbIntern("round"), 1, []ruby.VALUE{ruby.VALUE(ndigits)})

	return C.VALUE(result)
}

//export rb_dummy_tests_rb_alias
func rb_dummy_tests_rb_alias(klass C.VALUE, dst C.VALUE, src C.VALUE) {
	dstName := ruby.Value2String(ruby.VALUE(dst))
	dstID := ruby.RbIntern(dstName)

	srcName := ruby.Value2String(ruby.VALUE(src))
	srcID := ruby.RbIntern(srcName)

	ruby.RbAlias(ruby.VALUE(klass), dstID, srcID)
}

//export rb_dummy_tests_rb_class2name
func rb_dummy_tests_rb_class2name(klass C.VALUE) C.VALUE {
	str := ruby.RbClass2Name(ruby.VALUE(klass))
	value := ruby.String2Value(str)
	return C.VALUE(value)
}

//export rb_dummy_tests_rb_attr
func rb_dummy_tests_rb_attr(klass C.VALUE, name C.VALUE, needReader C.VALUE, needWriter C.VALUE, honourVisibility C.VALUE) {
	ivarName := ruby.Value2String(ruby.VALUE(name))
	intNeedReader := ruby.NUM2INT(ruby.VALUE(needReader))
	intNeedWriter := ruby.NUM2INT(ruby.VALUE(needWriter))
	intHonourVisibility := ruby.NUM2INT(ruby.VALUE(honourVisibility))

	ruby.RbAttr(ruby.VALUE(klass), ruby.RbIntern(ivarName), intNeedReader != 0, intNeedWriter != 0, intHonourVisibility != 0)
}

//export rb_dummy_tests_rb_const_get
func rb_dummy_tests_rb_const_get(klass C.VALUE, name C.VALUE) C.VALUE {
	constName := ruby.Value2String(ruby.VALUE(name))
	constID := ruby.RbIntern(constName)
	return C.VALUE(ruby.RbConstGet(ruby.VALUE(klass), constID))
}

//export rb_dummy_tests_rb_const_get_at
func rb_dummy_tests_rb_const_get_at(klass C.VALUE, name C.VALUE) C.VALUE {
	constName := ruby.Value2String(ruby.VALUE(name))
	constID := ruby.RbIntern(constName)
	return C.VALUE(ruby.RbConstGetAt(ruby.VALUE(klass), constID))
}

//export rb_dummy_tests_rb_const_set
func rb_dummy_tests_rb_const_set(klass C.VALUE, name C.VALUE, val C.VALUE) {
	constName := ruby.Value2String(ruby.VALUE(name))
	constID := ruby.RbIntern(constName)

	ruby.RbConstSet(ruby.VALUE(klass), constID, ruby.VALUE(val))
}

//export rb_dummy_tests_rb_const_defined
func rb_dummy_tests_rb_const_defined(klass C.VALUE, name C.VALUE) C.VALUE {
	constName := ruby.Value2String(ruby.VALUE(name))
	constID := ruby.RbIntern(constName)

	defined := ruby.RbConstDefined(ruby.VALUE(klass), constID)
	if defined {
		return C.VALUE(ruby.Qtrue())
	}

	return C.VALUE(ruby.Qfalse())
}

//export rb_dummy_tests_rb_const_defined_at
func rb_dummy_tests_rb_const_defined_at(klass C.VALUE, name C.VALUE) C.VALUE {
	constName := ruby.Value2String(ruby.VALUE(name))
	constID := ruby.RbIntern(constName)

	defined := ruby.RbConstDefinedAt(ruby.VALUE(klass), constID)
	if defined {
		return C.VALUE(ruby.Qtrue())
	}

	return C.VALUE(ruby.Qfalse())
}

//export rb_dummy_tests_rb_eval_string
func rb_dummy_tests_rb_eval_string(_ C.VALUE, str C.VALUE) C.VALUE {
	goStr := ruby.Value2String(ruby.VALUE(str))
	ret := ruby.RbEvalString(goStr)

	return C.VALUE(ret)
}

// defineMethodsToDummyTests define methods in Dummy::Tests
func defineMethodsToDummyTests(rb_mDummy ruby.VALUE) {
	rb_cTests := ruby.RbDefineClassUnder(rb_mDummy, "Tests", ruby.VALUE(C.rb_cObject))

	ruby.RbDefineMethod(rb_cTests, "rb_ivar_get", C.rb_dummy_tests_rb_ivar_get, 0)
	ruby.RbDefineMethod(rb_cTests, "rb_ivar_set", C.rb_dummy_tests_rb_ivar_set, 1)

	ruby.RbDefineSingletonMethod(rb_cTests, "rb_yield", C.rb_dummy_tests_rb_yield, 1)
	ruby.RbDefineSingletonMethod(rb_cTests, "rb_block_proc", C.rb_dummy_tests_rb_block_proc, 1)
	ruby.RbDefineSingletonMethod(rb_cTests, "rb_funcall2", C.rb_dummy_tests_rb_funcall2, 2)
	ruby.RbDefineSingletonMethod(rb_cTests, "rb_funcall3", C.rb_dummy_tests_rb_funcall3, 2)
	ruby.RbDefineSingletonMethod(rb_cTests, "rb_alias", C.rb_dummy_tests_rb_alias, 2)
	ruby.RbDefineSingletonMethod(rb_cTests, "rb_class2name", C.rb_dummy_tests_rb_class2name, 0)
	ruby.RbDefineSingletonMethod(rb_cTests, "rb_attr", C.rb_dummy_tests_rb_attr, 4)
	ruby.RbDefineSingletonMethod(rb_cTests, "rb_const_get", C.rb_dummy_tests_rb_const_get, 1)
	ruby.RbDefineSingletonMethod(rb_cTests, "rb_const_get_at", C.rb_dummy_tests_rb_const_get_at, 1)
	ruby.RbDefineSingletonMethod(rb_cTests, "rb_const_set", C.rb_dummy_tests_rb_const_set, 2)
	ruby.RbDefineSingletonMethod(rb_cTests, "rb_const_defined", C.rb_dummy_tests_rb_const_defined, 1)
	ruby.RbDefineSingletonMethod(rb_cTests, "rb_const_defined_at", C.rb_dummy_tests_rb_const_defined_at, 1)
	ruby.RbDefineSingletonMethod(rb_cTests, "rb_eval_string", C.rb_dummy_tests_rb_eval_string, 1)
}
