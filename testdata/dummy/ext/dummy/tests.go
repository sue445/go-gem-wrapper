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
	sourceID := ruby.RbIntern("@source")
	sourceValue := ruby.RbIvarGet(ruby.VALUE(self), sourceID)

	sourceInt := ruby.NUM2INT(sourceValue)
	result := sourceInt * 1024

	return C.VALUE(ruby.INT2NUM(result))
}

//export rb_dummy_tests_increment
func rb_dummy_tests_increment(self C.VALUE) C.VALUE {
	sourceID := ruby.RbIntern("@source")
	sourceValue := ruby.RbIvarGet(ruby.VALUE(self), sourceID)

	sourceInt := ruby.NUM2INT(sourceValue)
	sourceInt++

	result := ruby.INT2NUM(sourceInt)
	ruby.RbIvarSet(ruby.VALUE(self), sourceID, result)

	return C.VALUE(result)
}
