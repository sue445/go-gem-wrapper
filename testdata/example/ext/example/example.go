package main

/*
#include "example.h"

VALUE rb_example_sum(VALUE self, VALUE a, VALUE b);
VALUE rb_example_hello(VALUE self, VALUE name);
VALUE rb_example_to_string(VALUE self, VALUE source);
VALUE rb_example_max(VALUE self, VALUE a, VALUE b);
*/
import "C"

import (
	ruby "github.com/sue445/go-gem-wrapper"
)

//export rb_example_sum
func rb_example_sum(_ C.VALUE, a C.VALUE, b C.VALUE) C.VALUE {
	aLong := ruby.NUM2LONG(ruby.VALUE(a))
	bLong := ruby.NUM2LONG(ruby.VALUE(b))

	sum := aLong + bLong

	return C.VALUE(ruby.LONG2NUM(sum))
}

//export rb_example_hello
func rb_example_hello(_ C.VALUE, name C.VALUE) C.VALUE {
	nameString := ruby.Value2String(ruby.VALUE(name))
	result := "Hello, " + nameString
	return C.VALUE(ruby.String2Value(result))
}

//export rb_example_to_string
func rb_example_to_string(_ C.VALUE, source C.VALUE) C.VALUE {
	// Call Object#to_s
	result := ruby.CallFunction(ruby.VALUE(source), "to_s")

	return C.VALUE(result)
}

//export rb_example_max
func rb_example_max(_ C.VALUE, a C.VALUE, b C.VALUE) C.VALUE {
	aLong := ruby.NUM2INT(ruby.VALUE(a))
	bLong := ruby.NUM2INT(ruby.VALUE(b))

	if aLong > bLong {
		return C.VALUE(ruby.INT2NUM(aLong))
	}

	return C.VALUE(ruby.INT2NUM(bLong))
}

//export Init_example
func Init_example() {
	rb_mExample := ruby.RbDefineModule("Example")

	ruby.RbDefineSingletonMethod(rb_mExample, "sum", C.rb_example_sum, 2)
	ruby.RbDefineSingletonMethod(rb_mExample, "hello", C.rb_example_hello, 1)
	ruby.RbDefineSingletonMethod(rb_mExample, "to_string", C.rb_example_to_string, 1)
	ruby.RbDefineModuleFunction(rb_mExample, "max", C.rb_example_max, 2)

	// Create Example::TestRbDefineClassUnder class
	ruby.RbDefineClassUnder(rb_mExample, "TestRbDefineClassUnder", ruby.VALUE(C.rb_cObject))

	// Create Example::TestRbDefineModuleUnder module
	ruby.RbDefineModuleUnder(rb_mExample, "TestRbDefineModuleUnder")

	// Create OuterClass class
	ruby.RbDefineClass("TestRbDefineClass", ruby.VALUE(C.rb_cObject))

	defineMethodsToExampleTests(rb_mExample)
	defineMethodsToExampleGoStruct(rb_mExample)
}

func main() {
}
