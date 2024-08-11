package ruby

/*
#include "ruby.h"
*/
import "C"

// c.f. https://github.com/ruby/ruby/blob/master/include/ruby/internal/intern/array.h

// RbAryNew calls `rb_ary_new` in C
//
// Original definition is following
//
//	VALUE rb_ary_new(void)
func RbAryNew() VALUE {
	return VALUE(C.rb_ary_new())
}
