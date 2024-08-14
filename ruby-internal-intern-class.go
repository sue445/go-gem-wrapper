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
func RbDefineSingletonMethod(obj VALUE, mid string, fun unsafe.Pointer, arity int) {
	char, clean := string2Char(mid)
	defer clean()

	C.rb_define_singleton_method(C.VALUE(obj), char, toFunctionPointer(fun), C.int(arity))
}

// RbDefineMethodId calls `rb_define_method_id` in C
//
// Original definition is following
//
//	void rb_define_method_id(VALUE klass, ID mid, VALUE (*func)(ANYARGS), int arity)
func RbDefineMethodId(klass VALUE, mid ID, fun unsafe.Pointer, arity int) {
	C.rb_define_method_id(C.VALUE(klass), C.ID(mid), toFunctionPointer(fun), C.int(arity))
}

// RbDefinePrivateMethod calls `rb_define_private_method` in C
//
// Original definition is following
//
//	void rb_define_private_method(VALUE klass, const char *mid, VALUE (*func)(ANYARGS), int arity)
func RbDefinePrivateMethod(klass VALUE, mid string, fun unsafe.Pointer, arity int) {
	char, clean := string2Char(mid)
	defer clean()

	C.rb_define_private_method(C.VALUE(klass), char, toFunctionPointer(fun), C.int(arity))
}

// RbDefineProtectedMethod calls `rb_define_protected_method` in C
//
// Original definition is following
//
//	void rb_define_protected_method(VALUE klass, const char *mid, VALUE (*func)(ANYARGS), int arity)
func RbDefineProtectedMethod(klass VALUE, mid string, fun unsafe.Pointer, arity int) {
	char, clean := string2Char(mid)
	defer clean()

	C.rb_define_protected_method(C.VALUE(klass), char, toFunctionPointer(fun), C.int(arity))
}
