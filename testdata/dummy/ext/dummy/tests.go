package main

/*
#include "dummy.h"

VALUE rb_dummy_tests_rb_ivar_get(VALUE self);
void  rb_dummy_tests_rb_ivar_set(VALUE self, VALUE value);
VALUE rb_dummy_tests_rb_yield(VALUE self, VALUE arg);
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

// defineMethodsToDummyTests define methods in Dummy::Tests
func defineMethodsToDummyTests(rb_mDummy ruby.VALUE) {
	rb_cTests := ruby.RbDefineClassUnder(rb_mDummy, "Tests", ruby.VALUE(C.rb_cObject))

	ruby.RbDefineMethod(rb_cTests, "rb_ivar_get", C.rb_dummy_tests_rb_ivar_get, 0)
	ruby.RbDefineMethod(rb_cTests, "rb_ivar_set", C.rb_dummy_tests_rb_ivar_set, 1)

	ruby.RbDefineSingletonMethod(rb_cTests, "rb_yield", C.rb_dummy_tests_rb_yield, 1)
}
