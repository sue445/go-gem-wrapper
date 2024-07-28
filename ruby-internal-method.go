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
	C.rb_define_method(C.VALUE(klass), string2Char(mid), toFunctionPointer(fun), C.int(arity))
}
