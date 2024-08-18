package ruby

/*
#include "ruby.h"
*/
import "C"
import "unsafe"

// c.f. https://github.com/ruby/ruby/blob/master/include/ruby/internal/method.h

// RbDefineMethod calls `rb_define_method` in C
//
// Original definition is following
//
//	void rb_define_method(VALUE klass, const char *mid, VALUE (*func)(ANYARGS), int arity)
func RbDefineMethod(klass VALUE, mid string, fun unsafe.Pointer, arity int) {
	char, clean := string2Char(mid)
	defer clean()

	C.rb_define_method(C.VALUE(klass), char, toFunctionPointer(fun), C.int(arity))
}

// RbDefineModuleFunction calls `rb_define_module_function` in C
//
// Original definition is following
//
//	void rb_define_module_function(VALUE klass, const char *mid, VALUE (*func)(ANYARGS), int arity)
//
// Example
//
//	/*
//	package main
//
//	#include "example.h"
//
//	VALUE rb_example_max(VALUE self, VALUE a, VALUE b);
//	*/
//	import "C"
//
//	//export rb_example_max
//	func rb_example_max(_ C.VALUE, a C.VALUE, b C.VALUE) C.VALUE {
//		aLong := ruby.NUM2INT(ruby.VALUE(a))
//		bLong := ruby.NUM2INT(ruby.VALUE(b))
//
//		if aLong > bLong {
//			return C.VALUE(ruby.INT2NUM(aLong))
//		}
//
//		return C.VALUE(ruby.INT2NUM(bLong))
//	}
//
//	//export Init_example
//	func Init_example() {
//		rb_mExample := ruby.RbDefineModule("Example")
//
//		ruby.RbDefineModuleFunction(rb_mExample, "max", C.rb_example_max, 2)
//	}
func RbDefineModuleFunction(klass VALUE, mid string, fun unsafe.Pointer, arity int) {
	char, clean := string2Char(mid)
	defer clean()

	C.rb_define_module_function(C.VALUE(klass), char, toFunctionPointer(fun), C.int(arity))
}
