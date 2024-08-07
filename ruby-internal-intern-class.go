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
	charMid, cleanCharMid := string2Char(mid)
	defer cleanCharMid()

	C.rb_define_singleton_method(C.VALUE(obj), charMid, toFunctionPointer(fun), C.int(arity))
}
