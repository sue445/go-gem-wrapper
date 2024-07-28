package ruby

/*
#include "ruby.h"
*/
import "C"

// c.f. https://github.com/ruby/ruby/blob/master/include/ruby/internal/variable.h

// RbIvarGet calls `rb_ivar_get` in C
//
// Original definition is following
//
//	VALUE rb_ivar_get(VALUE obj, ID name)
func RbIvarGet(obj VALUE, name ID) VALUE {
	return VALUE(C.rb_ivar_get(C.VALUE(obj), C.ID(name)))
}
