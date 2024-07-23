package main

/*
#include "dummy.h"

VALUE rb_dummy_sum(VALUE self, VALUE a, VALUE b);
*/
import "C"

import (
	"github.com/sue445/go-gem-wrapper"
)

//export rb_dummy_sum
func rb_dummy_sum(_ C.VALUE, a C.VALUE, b C.VALUE) C.VALUE {
	aLong := ruby.RbNum2long(ruby.VALUE(a))
	bLong := ruby.RbNum2long(ruby.VALUE(b))

	sum := aLong + bLong

	return C.VALUE(ruby.RbLong2numInline(sum))
}

var rb_mDummy ruby.VALUE

//export Init_dummy
func Init_dummy() {
	rb_mDummy = ruby.RbDefineModule("Dummy")
	ruby.RbDefineSingletonMethod(rb_mDummy, "sum", C.rb_dummy_sum, 2)
}

func main() {
}
