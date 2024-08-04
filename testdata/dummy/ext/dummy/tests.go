package main

/*
#include "dummy.h"
*/
import "C"

import (
	"github.com/sue445/go-gem-wrapper"
)

//export rb_dummy_tests_kilobyte
func rb_dummy_tests_kilobyte(self C.VALUE) C.VALUE {
	ivarID := ruby.RbIntern("@ivar")
	ivarValue := ruby.RbIvarGet(ruby.VALUE(self), ivarID)

	ivarInt := ruby.NUM2INT(ivarValue)
	result := ivarInt * 1024

	return C.VALUE(ruby.INT2NUM(result))
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
