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

// RbIvarSet calls `rb_ivar_set` in C
//
// Original definition is following
//
//	VALUE rb_ivar_set(VALUE obj, ID name, VALUE val)
func RbIvarSet(obj VALUE, name ID, val VALUE) VALUE {
	return VALUE(C.rb_ivar_set(C.VALUE(obj), C.ID(name), C.VALUE(val)))
}

// RbConstGet calls `rb_const_get` in C
//
// Original definition is following
//
//	VALUE rb_const_get(VALUE space, ID name)
func RbConstGet(space VALUE, name ID) VALUE {
	return VALUE(C.rb_const_get(C.VALUE(space), C.ID(name)))
}

// RbConstSet calls `rb_const_set` in C
//
// Original definition is following
//
//	void rb_const_set(VALUE space, ID name, VALUE val)
func RbConstSet(space VALUE, name ID, val VALUE) {
	C.rb_const_set(C.VALUE(space), C.ID(name), C.VALUE(val))
}
