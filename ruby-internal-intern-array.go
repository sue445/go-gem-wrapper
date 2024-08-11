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

// RbAryPush calls `rb_ary_push` in C
//
// Original definition is following
//
//	VALUE rb_ary_push(VALUE ary, VALUE elem)
func RbAryPush(ary VALUE, elem VALUE) VALUE {
	return VALUE(C.rb_ary_push(C.VALUE(ary), C.VALUE(elem)))
}
