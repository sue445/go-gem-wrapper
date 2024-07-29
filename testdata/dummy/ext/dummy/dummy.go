package main

/*
#include "dummy.h"

VALUE rb_dummy_sum(VALUE self, VALUE a, VALUE b);
VALUE rb_dummy_with_block(VALUE self, VALUE arg);
VALUE rb_dummy_hello(VALUE self, VALUE name);
VALUE rb_dummy_unit_kilobyte(VALUE self);
*/
import "C"

import (
	"github.com/sue445/go-gem-wrapper"
)

//export rb_dummy_sum
func rb_dummy_sum(_ C.VALUE, a C.VALUE, b C.VALUE) C.VALUE {
	aLong := ruby.NUM2LONG(ruby.VALUE(a))
	bLong := ruby.NUM2LONG(ruby.VALUE(b))

	sum := aLong + bLong

	return C.VALUE(ruby.LONG2NUM(sum))
}

//export rb_dummy_with_block
func rb_dummy_with_block(_ C.VALUE, arg C.VALUE) C.VALUE {
	if !ruby.RbBlockGivenP() {
		ruby.RbRaise(ruby.VALUE(C.rb_eArgError), "Block not given")
	}

	blockResult := ruby.RbYield(ruby.VALUE(arg))
	return C.VALUE(blockResult)
}

//export rb_dummy_hello
func rb_dummy_hello(_ C.VALUE, name C.VALUE) C.VALUE {
	nameString := ruby.Value2String(ruby.VALUE(name))
	result := "Hello, " + nameString
	return C.VALUE(ruby.String2Value(result))
}

//export rb_dummy_unit_kilobyte
func rb_dummy_unit_kilobyte(self C.VALUE) C.VALUE {
	sourceID := ruby.RbIntern("@source")
	sourceValue := ruby.RbIvarGet(ruby.VALUE(self), sourceID)

	sourceLong := ruby.NUM2LONG(sourceValue)
	result := sourceLong * 1024

	return C.VALUE(ruby.LONG2NUM(result))
}

var rb_mDummy ruby.VALUE

//export Init_dummy
func Init_dummy() {
	rb_mDummy = ruby.RbDefineModule("Dummy")
	ruby.RbDefineSingletonMethod(rb_mDummy, "sum", C.rb_dummy_sum, 2)
	ruby.RbDefineSingletonMethod(rb_mDummy, "with_block", C.rb_dummy_with_block, 1)
	ruby.RbDefineSingletonMethod(rb_mDummy, "hello", C.rb_dummy_hello, 1)

	// Create Dummy::InnerClass class
	ruby.RbDefineClassUnder(rb_mDummy, "InnerClass", ruby.VALUE(C.rb_cObject))

	// Create Dummy::InnerModule module
	ruby.RbDefineModuleUnder(rb_mDummy, "InnerModule")

	// Create OuterClass class
	ruby.RbDefineClass("OuterClass", ruby.VALUE(C.rb_cObject))

	// Dummy::Unit
	rb_cUnit := ruby.RbDefineClassUnder(rb_mDummy, "Unit", ruby.VALUE(C.rb_cObject))
	ruby.RbDefineMethod(rb_cUnit, "kilobyte", C.rb_dummy_unit_kilobyte, 0)
}

func main() {
}
