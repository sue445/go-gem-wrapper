// THE AUTOGENERATED LICENSE. ALL THE RIGHTS ARE RESERVED BY ROBOTS.

// WARNING: This file has automatically been generated
// Code generated by ruby_h_to_go. DO NOT EDIT.

package ruby

/*
#include "ruby.h"
*/
import "C"

// RbNum2Ll calls `rb_num2ll` in C
//
// Original definition is following
//
//	LONG_LONG rb_num2ll(VALUE num)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/arithmetic/long_long.h
func RbNum2Ll(num VALUE) Longlong {
	ret := Longlong(C.rb_num2ll(C.VALUE(num)))
	return ret
}

// RbNum2Ull calls `rb_num2ull` in C
//
// Original definition is following
//
//	unsigned LONG_LONG rb_num2ull(VALUE num)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/arithmetic/long_long.h
func RbNum2Ull(num VALUE) Ulonglong {
	ret := Ulonglong(C.rb_num2ull(C.VALUE(num)))
	return ret
}

// RbUll2Inum calls `rb_ull2inum` in C
//
// Original definition is following
//
//	VALUE rb_ull2inum(unsigned LONG_LONG num)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/arithmetic/long_long.h
func RbUll2Inum(num Ulonglong) VALUE {
	ret := VALUE(C.rb_ull2inum(C.ulonglong(num)))
	return ret
}

// RbNum2LlInline calls `rb_num2ll_inline` in C
//
// Original definition is following
//
//	rb_num2ll_inline(VALUE x)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/arithmetic/long_long.h
func RbNum2LlInline(x VALUE) Longlong {
	ret := Longlong(C.rb_num2ll_inline(C.VALUE(x)))
	return ret
}

// RbNum2UllInline calls `rb_num2ull_inline` in C
//
// Original definition is following
//
//	rb_num2ull_inline(VALUE x)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/arithmetic/long_long.h
func RbNum2UllInline(x VALUE) Ulonglong {
	ret := Ulonglong(C.rb_num2ull_inline(C.VALUE(x)))
	return ret
}

// RbUll2NumInline calls `rb_ull2num_inline` in C
//
// Original definition is following
//
//	rb_ull2num_inline(unsigned LONG_LONG n)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/arithmetic/long_long.h
func RbUll2NumInline(n Ulonglong) VALUE {
	ret := VALUE(C.rb_ull2num_inline(C.ulonglong(n)))
	return ret
}
