package ruby

/*
#include "ruby.h"
*/
import "C"

// c.f. https://github.com/ruby/ruby/blob/master/include/ruby/internal/iterator.h

// RbYield calls `rb_yield` in C
//
// Original definition is following
//
//	VALUE rb_yield(VALUE val)
func RbYield(val VALUE) VALUE {
	return VALUE(C.rb_yield(C.VALUE(val)))
}

// RbBlockGivenP calls `rb_block_given_p` in C
//
// Original definition is following
//
//	int rb_block_given_p(void)
func RbBlockGivenP() bool {
	ret := C.rb_block_given_p()
	return ret != 0
}
