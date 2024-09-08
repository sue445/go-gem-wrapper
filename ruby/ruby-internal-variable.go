package ruby

/*
#include "ruby.h"
*/
import "C"

// c.f. https://github.com/ruby/ruby/blob/master/include/ruby/internal/variable.h

// RbDefineVariable calls `rb_define_variable` in C
//
// Original definition is following
//
//	void rb_define_variable(const char *name, VALUE *var)
func RbDefineVariable(name string, v *VALUE) {
	char, clean := string2Char(name)
	defer clean()

	C.rb_define_variable(char, (*C.VALUE)(v))
}

// RbDefineConst calls `rb_define_const` in C
//
// Original definition is following
//
//	void rb_define_const(VALUE klass, const char *name, VALUE val)
func RbDefineConst(klass VALUE, name string, val VALUE) {
	char, clean := string2Char(name)
	defer clean()

	C.rb_define_const(C.VALUE(klass), char, C.VALUE(val))
}
