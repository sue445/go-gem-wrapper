package ruby

/*
#include "ruby.h"
*/
import "C"

// c.f. https://github.com/ruby/ruby/blob/master/include/ruby/internal/arithmetic/long.h

// RbNum2long calls `rb_num2long` in C
//
// Original definition is following
//
//	long rb_num2long(VALUE num)
func RbNum2long(num VALUE) Long {
	return Long(C.rb_num2long(C.VALUE(num)))
}

// NUM2LONG is alias to [RbNum2long]
func NUM2LONG(num VALUE) Long {
	return RbNum2long(num)
}

// RbLong2numInline calls `rb_long2num_inline` in C
//
// Original definition is following
//
//	VALUE rb_long2num_inline(long v)
func RbLong2numInline(v Long) VALUE {
	return VALUE(C.rb_long2num_inline(C.long(v)))
}

// LONG2NUM is alias to [RbLong2numInline]
func LONG2NUM(v Long) VALUE {
	return RbLong2numInline(v)
}
