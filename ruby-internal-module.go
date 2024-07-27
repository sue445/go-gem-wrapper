package ruby

/*
#include "ruby.h"
*/
import "C"

// c.f. https://github.com/ruby/ruby/blob/master/include/ruby/internal/module.h

// RbDefineModule calls `rb_define_module` in C
//
// Original definition is following
//
//	VALUE rb_define_module(const char *name)
func RbDefineModule(name string) VALUE {
	return VALUE(C.rb_define_module(string2Char(name)))
}

// RbDefineClassUnder calls `rb_define_class_under` in C
//
// Original definition is following
//
//	VALUE rb_define_class_under(VALUE outer, const char *name, VALUE super)
func RbDefineClassUnder(outer VALUE, name string, super VALUE) VALUE {
	return VALUE(C.rb_define_class_under(C.VALUE(outer), string2Char(name), C.VALUE(super)))
}
