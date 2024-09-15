package ruby

/*
#include "ruby.h"
*/
import "C"

import (
	"unsafe"
)

// c.f. https://github.com/ruby/ruby/blob/master/include/ruby/internal/intern/class.h

// RbDefineSingletonMethod calls `rb_define_singleton_method` in C
//
// Original definition is following
//
//	void rb_define_singleton_method(VALUE obj, const char *mid, VALUE(*func)(ANYARGS), int arity)
//
// Example
//
//	/*
//	package main
//
//	#include "example.h"
//
//	VALUE rb_example_sum(VALUE self, VALUE a, VALUE b);
//	*/
//	import "C"
//
//	//export rb_example_sum
//	func rb_example_sum(_ C.VALUE, a C.VALUE, b C.VALUE) C.VALUE {
//		aLong := ruby.NUM2LONG(ruby.VALUE(a))
//		bLong := ruby.NUM2LONG(ruby.VALUE(b))
//
//		sum := aLong + bLong
//
//		return C.VALUE(ruby.LONG2NUM(sum))
//	}
//
//	//export Init_example
//	func Init_example() {
//		rb_mExample := ruby.RbDefineModule("Example")
//
//		ruby.RbDefineSingletonMethod(rb_mExample, "sum", C.rb_example_sum, 2)
//	}
func RbDefineSingletonMethod(obj VALUE, mid string, fun unsafe.Pointer, arity int) {
	char, clean := string2Char(mid)
	defer clean()

	C.rb_define_singleton_method(C.VALUE(obj), char, toCPointer(fun), C.int(arity))
}

// RbDefineMethodId calls `rb_define_method_id` in C
//
// Original definition is following
//
//	void rb_define_method_id(VALUE klass, ID mid, VALUE (*func)(ANYARGS), int arity)
func RbDefineMethodId(klass VALUE, mid ID, fun unsafe.Pointer, arity int) {
	C.rb_define_method_id(C.VALUE(klass), C.ID(mid), toCPointer(fun), C.int(arity))
}

// RbDefinePrivateMethod calls `rb_define_private_method` in C
//
// Original definition is following
//
//	void rb_define_private_method(VALUE klass, const char *mid, VALUE (*func)(ANYARGS), int arity)
func RbDefinePrivateMethod(klass VALUE, mid string, fun unsafe.Pointer, arity int) {
	char, clean := string2Char(mid)
	defer clean()

	C.rb_define_private_method(C.VALUE(klass), char, toCPointer(fun), C.int(arity))
}

// RbDefineProtectedMethod calls `rb_define_protected_method` in C
//
// Original definition is following
//
//	void rb_define_protected_method(VALUE klass, const char *mid, VALUE (*func)(ANYARGS), int arity)
func RbDefineProtectedMethod(klass VALUE, mid string, fun unsafe.Pointer, arity int) {
	char, clean := string2Char(mid)
	defer clean()

	C.rb_define_protected_method(C.VALUE(klass), char, toCPointer(fun), C.int(arity))
}
