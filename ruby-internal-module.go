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
	nameChar, nameCharClean := string2Char(name)
	defer nameCharClean()

	return VALUE(C.rb_define_module(nameChar))
}

// RbDefineClassUnder calls `rb_define_class_under` in C
//
// Original definition is following
//
//	VALUE rb_define_class_under(VALUE outer, const char *name, VALUE super)
func RbDefineClassUnder(outer VALUE, name string, super VALUE) VALUE {
	nameChar, nameCharClean := string2Char(name)
	defer nameCharClean()

	return VALUE(C.rb_define_class_under(C.VALUE(outer), nameChar, C.VALUE(super)))
}

// RbDefineModuleUnder calls `rb_define_module_under` in C
//
// Original definition is following
//
//	VALUE rb_define_module_under(VALUE outer, const char *name)
func RbDefineModuleUnder(outer VALUE, name string) VALUE {
	nameChar, nameCharClean := string2Char(name)
	defer nameCharClean()

	return VALUE(C.rb_define_module_under(C.VALUE(outer), nameChar))
}

// RbDefineClass calls `rb_define_class` in C
//
// Original definition is following
//
//	VALUE rb_define_class(const char *name, VALUE super)
func RbDefineClass(name string, super VALUE) VALUE {
	nameChar, nameChsrClean := string2Char(name)
	defer nameChsrClean()

	return VALUE(C.rb_define_class(nameChar, C.VALUE(super)))
}
