package main

/*
#include "dummy.h"

VALUE rb_dummy_sum(VALUE self, VALUE a, VALUE b);
VALUE rb_dummy_hello(VALUE self, VALUE name);
VALUE rb_dummy_to_string(VALUE self, VALUE source);
VALUE rb_dummy_max(VALUE self, VALUE a, VALUE b);
VALUE go_struct_alloc(VALUE klass);
*/
import "C"

import (
	ruby "github.com/sue445/go-gem-wrapper"
	"unsafe"
)

//export rb_dummy_sum
func rb_dummy_sum(_ C.VALUE, a C.VALUE, b C.VALUE) C.VALUE {
	aLong := ruby.NUM2LONG(ruby.VALUE(a))
	bLong := ruby.NUM2LONG(ruby.VALUE(b))

	sum := aLong + bLong

	return C.VALUE(ruby.LONG2NUM(sum))
}

//export rb_dummy_hello
func rb_dummy_hello(_ C.VALUE, name C.VALUE) C.VALUE {
	nameString := ruby.Value2String(ruby.VALUE(name))
	result := "Hello, " + nameString
	return C.VALUE(ruby.String2Value(result))
}

//export rb_dummy_to_string
func rb_dummy_to_string(_ C.VALUE, source C.VALUE) C.VALUE {
	// Call Object#to_s
	result := ruby.CallFunction(ruby.VALUE(source), "to_s")

	return C.VALUE(result)
}

//export rb_dummy_max
func rb_dummy_max(_ C.VALUE, a C.VALUE, b C.VALUE) C.VALUE {
	aLong := ruby.NUM2INT(ruby.VALUE(a))
	bLong := ruby.NUM2INT(ruby.VALUE(b))

	if aLong > bLong {
		return C.VALUE(ruby.INT2NUM(aLong))
	}

	return C.VALUE(ruby.INT2NUM(bLong))
}

// GoStruct is internal reality of Ruby `Dummy::GoStruct`
type GoStruct struct {
	x int
	y int
}

//export go_struct_alloc
func go_struct_alloc(klass C.VALUE) C.VALUE {
	data := GoStruct{}
	return C.VALUE(ruby.NewGoStruct(ruby.VALUE(klass), unsafe.Pointer(&data)))
}

//export Init_dummy
func Init_dummy() {
	rb_mDummy := ruby.RbDefineModule("Dummy")

	ruby.RbDefineSingletonMethod(rb_mDummy, "sum", C.rb_dummy_sum, 2)
	ruby.RbDefineSingletonMethod(rb_mDummy, "hello", C.rb_dummy_hello, 1)
	ruby.RbDefineSingletonMethod(rb_mDummy, "to_string", C.rb_dummy_to_string, 1)
	ruby.RbDefineModuleFunction(rb_mDummy, "max", C.rb_dummy_max, 2)

	// Create Dummy::TestRbDefineClassUnder class
	ruby.RbDefineClassUnder(rb_mDummy, "TestRbDefineClassUnder", ruby.VALUE(C.rb_cObject))

	// Create Dummy::TestRbDefineModuleUnder module
	ruby.RbDefineModuleUnder(rb_mDummy, "TestRbDefineModuleUnder")

	// Create OuterClass class
	ruby.RbDefineClass("TestRbDefineClass", ruby.VALUE(C.rb_cObject))

	// Create Dummy::GoStruct class
	rb_cGoStruct := ruby.RbDefineClassUnder(rb_mDummy, "GoStruct", ruby.VALUE(C.rb_cObject))

	ruby.RbDefineAllocFunc(rb_cGoStruct, C.go_struct_alloc)

	defineMethodsToDummyTests(rb_mDummy)
}

func main() {
}
