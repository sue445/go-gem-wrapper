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
	char, clean := string2Char(name)
	defer clean()

	return VALUE(C.rb_define_module(char))
}

// RbDefineClassUnder calls `rb_define_class_under` in C
//
// Original definition is following
//
//	VALUE rb_define_class_under(VALUE outer, const char *name, VALUE super)
func RbDefineClassUnder(outer VALUE, name string, super VALUE) VALUE {
	char, clean := string2Char(name)
	defer clean()

	return VALUE(C.rb_define_class_under(C.VALUE(outer), char, C.VALUE(super)))
}

// RbDefineModuleUnder calls `rb_define_module_under` in C
//
// Original definition is following
//
//	VALUE rb_define_module_under(VALUE outer, const char *name)
func RbDefineModuleUnder(outer VALUE, name string) VALUE {
	char, clean := string2Char(name)
	defer clean()

	return VALUE(C.rb_define_module_under(C.VALUE(outer), char))
}

// RbDefineClass calls `rb_define_class` in C
//
// Original definition is following
//
//	VALUE rb_define_class(const char *name, VALUE super)
func RbDefineClass(name string, super VALUE) VALUE {
	char, clean := string2Char(name)
	defer clean()

	return VALUE(C.rb_define_class(char, C.VALUE(super)))
}
