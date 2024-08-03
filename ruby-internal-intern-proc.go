package ruby

/*
#include "ruby.h"
*/
import "C"

// c.f. https://github.com/ruby/ruby/blob/master/include/ruby/internal/intern/proc.h

// RbBlockProc calls `rb_block_proc` in C
//
// Original definition is following
//
//	VALUE rb_block_proc(void)
func RbBlockProc() VALUE {
	return VALUE(C.rb_block_proc())
}
