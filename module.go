package ruby

/*
#include "ruby.h"
*/
import "C"

// c.f. https://github.com/ruby/ruby/blob/master/include/ruby/internal/module.h

// RbDefineModule calls `rb_define_module` in C
func RbDefineModule(name string) VALUE {
	return VALUE(C.rb_define_module(string2Char(name)))
}
