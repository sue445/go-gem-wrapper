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
	midChar, midCharClean := string2Char(mid)
	defer midCharClean()

	C.rb_define_method(C.VALUE(klass), midChar, toFunctionPointer(fun), C.int(arity))
}

// RbDefineModuleFunction calls `rb_define_module_function` in C
//
// Original definition is following
//
//	void rb_define_module_function(VALUE klass, const char *mid, VALUE (*func)(ANYARGS), int arity)
func RbDefineModuleFunction(klass VALUE, mid string, fun unsafe.Pointer, arity int) {
	midChar, midCharClean := string2Char(mid)
	defer midCharClean()

	C.rb_define_module_function(C.VALUE(klass), midChar, toFunctionPointer(fun), C.int(arity))
}
