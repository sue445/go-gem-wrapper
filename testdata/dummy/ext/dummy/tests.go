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
*/
import "C"

import (
	"github.com/sue445/go-gem-wrapper"
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
}
