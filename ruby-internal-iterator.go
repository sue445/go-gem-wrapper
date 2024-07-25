package ruby

/*
#include "ruby.h"
*/
import "C"

// c.f. https://github.com/ruby/ruby/blob/master/include/ruby/internal/iterator.h

// RbYield calls `rb_yield` in C
func RbYield(val VALUE) VALUE {
	return VALUE(C.rb_yield(C.VALUE(val)))
}

// RbBlockGivenP calls `rb_block_given_p` in C
func RbBlockGivenP() bool {
	ret := C.rb_block_given_p()
	return ret != 0
}
