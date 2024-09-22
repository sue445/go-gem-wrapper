// THE AUTOGENERATED LICENSE. ALL THE RIGHTS ARE RESERVED BY ROBOTS.

// WARNING: This file has automatically been generated
// Code generated by ruby_h_to_go. DO NOT EDIT.

package ruby

/*
#include "ruby.h"
*/
import "C"

// RbStructAlloc calls `rb_struct_alloc` in C
//
// Original definition is following
//
//	VALUE rb_struct_alloc(VALUE klass, VALUE values)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/intern/struct.h
func RbStructAlloc(klass VALUE, values VALUE) VALUE {
	ret := VALUE(C.rb_struct_alloc(C.VALUE(klass), C.VALUE(values)))
	return ret
}

// RbStructAllocNoinit calls `rb_struct_alloc_noinit` in C
//
// Original definition is following
//
//	VALUE rb_struct_alloc_noinit(VALUE klass)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/intern/struct.h
func RbStructAllocNoinit(klass VALUE) VALUE {
	ret := VALUE(C.rb_struct_alloc_noinit(C.VALUE(klass)))
	return ret
}

// RbStructGetmember calls `rb_struct_getmember` in C
//
// Original definition is following
//
//	VALUE rb_struct_getmember(VALUE self, ID key)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/intern/struct.h
func RbStructGetmember(self VALUE, key ID) VALUE {
	ret := VALUE(C.rb_struct_getmember(C.VALUE(self), C.ID(key)))
	return ret
}

// RbStructInitialize calls `rb_struct_initialize` in C
//
// Original definition is following
//
//	VALUE rb_struct_initialize(VALUE self, VALUE values)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/intern/struct.h
func RbStructInitialize(self VALUE, values VALUE) VALUE {
	ret := VALUE(C.rb_struct_initialize(C.VALUE(self), C.VALUE(values)))
	return ret
}

// RbStructMembers calls `rb_struct_members` in C
//
// Original definition is following
//
//	VALUE rb_struct_members(VALUE self)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/intern/struct.h
func RbStructMembers(self VALUE) VALUE {
	ret := VALUE(C.rb_struct_members(C.VALUE(self)))
	return ret
}

// RbStructSMembers calls `rb_struct_s_members` in C
//
// Original definition is following
//
//	VALUE rb_struct_s_members(VALUE klass)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/intern/struct.h
func RbStructSMembers(klass VALUE) VALUE {
	ret := VALUE(C.rb_struct_s_members(C.VALUE(klass)))
	return ret
}
