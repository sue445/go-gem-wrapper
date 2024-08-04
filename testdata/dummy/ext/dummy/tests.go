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

//export rb_dummy_tests_rb_ivar_set
func rb_dummy_tests_rb_ivar_set(self C.VALUE, value C.VALUE) {
	ivarID := ruby.RbIntern("@ivar")
	ruby.RbIvarSet(ruby.VALUE(self), ivarID, ruby.VALUE(value))
}
