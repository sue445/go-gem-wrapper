package ruby

/*
#include "ruby.h"
*/
import "C"

// RbAlias calls `rb_alias` in C
//
// Original definition is following
//
//	void rb_alias(VALUE klass, ID dst, ID src)
func RbAlias(klass VALUE, dst ID, src ID) {
	C.rb_alias(C.VALUE(klass), C.ID(dst), C.ID(src))
}
