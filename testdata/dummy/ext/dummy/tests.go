package main

/*
#include "dummy.h"
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

//export rb_dummy_tests_increment
func rb_dummy_tests_increment(self C.VALUE) C.VALUE {
	ivarID := ruby.RbIntern("@ivar")
	ivarValue := ruby.RbIvarGet(ruby.VALUE(self), ivarID)

	ivarInt := ruby.NUM2INT(ivarValue)
	ivarInt++

	result := ruby.INT2NUM(ivarInt)
	ruby.RbIvarSet(ruby.VALUE(self), ivarID, result)

	return C.VALUE(result)
}
