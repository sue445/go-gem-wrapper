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

// RbAryNewCapa calls `rb_ary_new_capa` in C
//
// Original definition is following
//
//	VALUE rb_ary_new_capa(long capa)
func RbAryNewCapa(capa int64) VALUE {
	return VALUE(C.rb_ary_new_capa(C.long(capa)))
}

// RbAryNew2 is alias to [RbAryNewCapa]
func RbAryNew2(capa int64) VALUE {
	return RbAryNewCapa(capa)
}

// RbAryPush calls `rb_ary_push` in C
//
// Original definition is following
//
//	VALUE rb_ary_push(VALUE ary, VALUE elem)
func RbAryPush(ary VALUE, elem VALUE) VALUE {
	return VALUE(C.rb_ary_push(C.VALUE(ary), C.VALUE(elem)))
}

// RbAryPop calls `rb_ary_pop` in C
//
// Original definition is following
//
//	VALUE rb_ary_pop(VALUE ary)
func RbAryPop(ary VALUE) VALUE {
	return VALUE(C.rb_ary_pop(C.VALUE(ary)))
}
