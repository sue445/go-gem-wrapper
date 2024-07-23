package ruby

/*
#include "ruby.h"
*/
import "C"

// RbDefineModule calls `rb_define_module` in C
func RbDefineModule(name string) VALUE {
	return (VALUE)(C.rb_define_module(goString2Char(name)))
}
