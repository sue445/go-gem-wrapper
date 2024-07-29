package ruby

/*
#include "ruby.h"
*/
import "C"

// c.f. https://github.com/ruby/ruby/blob/master/include/ruby/internal/arithmetic/int.h

// RbNum2intInline calls `rb_num2int_inline` in C
//
// Original definition is following
//
//	int rb_num2int_inline(VALUE x)
func RbNum2intInline(x VALUE) Int {
	return Int(C.rb_num2int_inline(C.VALUE(x)))
}

// RbInt2numInline calls `rb_int2num_inline` in C
//
// Original definition is following
//
//	VALUE rb_int2num_inline(int v)
func RbInt2numInline(v Int) VALUE {
	return VALUE(C.rb_int2num_inline(C.int(v)))
}
