// THE AUTOGENERATED LICENSE. ALL THE RIGHTS ARE RESERVED BY ROBOTS.

// WARNING: This file has automatically been generated
// Code generated by ruby_h_to_go. DO NOT EDIT.

package ruby

/*
#include "ruby.h"
*/
import "C"

// RbClass2Name calls `rb_class2name` in C
//
// Original definition is following
//
//	const char *rb_class2name(VALUE klass)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/ruby.h
func RbClass2Name(klass VALUE) string {
	ret := string(C.rb_class2name(C.VALUE(klass)))
	return ret
}

// RbEqual calls `rb_equal` in C
//
// Original definition is following
//
//	VALUE rb_equal(VALUE lhs, VALUE rhs)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/ruby.h
func RbEqual(lhs VALUE, rhs VALUE) VALUE {
	ret := VALUE(C.rb_equal(C.VALUE(lhs), C.VALUE(rhs)))
	return ret
}

// RbErrno calls `rb_errno` in C
//
// Original definition is following
//
//	int rb_errno(void)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/ruby.h
func RbErrno() int {
	ret := int(C.rb_errno())
	return ret
}

// RbErrnoPtr calls `rb_errno_ptr` in C
//
// Original definition is following
//
//	int *rb_errno_ptr(void)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/ruby.h
func RbErrnoPtr() *int {
	ret := (*int)(C.rb_errno_ptr())
	return ret
}

// RbErrnoSet calls `rb_errno_set` in C
//
// Original definition is following
//
//	void rb_errno_set(int err)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/ruby.h
func RbErrnoSet(err int) {
	C.rb_errno_set(C.int(err))
}

// RbGetPathNoChecksafe calls `rb_get_path_no_checksafe` in C
//
// Original definition is following
//
//	VALUE rb_get_path_no_checksafe(VALUE)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/ruby.h
func RbGetPathNoChecksafe(arg1 VALUE) VALUE {
	ret := VALUE(C.rb_get_path_no_checksafe(C.VALUE(arg1)))
	return ret
}

// RbObjClassname calls `rb_obj_classname` in C
//
// Original definition is following
//
//	const char *rb_obj_classname(VALUE obj)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/ruby.h
func RbObjClassname(obj VALUE) string {
	ret := string(C.rb_obj_classname(C.VALUE(obj)))
	return ret
}

// RbP calls `rb_p` in C
//
// Original definition is following
//
//	void rb_p(VALUE obj)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/ruby.h
func RbP(obj VALUE) {
	C.rb_p(C.VALUE(obj))
}

// RbRequire calls `rb_require` in C
//
// Original definition is following
//
//	VALUE rb_require(const char *feature)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/ruby.h
func RbRequire(feature string) VALUE {
	char, clean := string2Char(feature)
	defer clean()

	ret := VALUE(C.rb_require(char))
	return ret
}

// RbOrigErrnoPtr calls `rb_orig_errno_ptr` in C
//
// Original definition is following
//
//	rb_orig_errno_ptr(void)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/ruby.h
func RbOrigErrnoPtr() *int {
	ret := (*int)(C.rb_orig_errno_ptr())
	return ret
}
