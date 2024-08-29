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
//
// Example
//
//	/*
//	package main
//
//	#include "example.h"
//	*/
//	import "C"
//
//	//export Init_example
//	func Init_example() {
//		rb_mExample := ruby.RbDefineModule("Example")
//	}
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
//
// Example
//
//	/*
//	package main
//
//	#include "example.h"
//	*/
//	import "C"
//
//	//export Init_example
//	func Init_example() {
//		rb_mExample := ruby.RbDefineModule("Example")
//
//		// Create Example::TestRbDefineClassUnder class
//		ruby.RbDefineClassUnder(rb_mExample, "TestRbDefineClassUnder", ruby.VALUE(C.rb_cObject))
//	}
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
//
// Example
//
//	/*
//	package main
//
//	#include "example.h"
//	*/
//	import "C"
//
//	//export Init_example
//	func Init_example() {
//		rb_mExample := ruby.RbDefineModule("Example")
//
//		// Create Example::TestRbDefineModuleUnder module
//		ruby.RbDefineModuleUnder(rb_mExample, "TestRbDefineModuleUnder")
//	}
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
//
// Example
//
//	/*
//	package main
//
//	#include "example.h"
//	*/
//	import "C"
//
//	//export Init_example
//	func Init_example() {
//		rb_mExample := ruby.RbDefineModule("Example")
//
//		// Create ::TestRbDefineClass class
//		ruby.RbDefineClass("TestRbDefineClass", ruby.VALUE(C.rb_cObject))
//	}
func RbDefineClass(name string, super VALUE) VALUE {
	char, clean := string2Char(name)
	defer clean()

	return VALUE(C.rb_define_class(char, C.VALUE(super)))
}
