package ruby

/*
#include "ruby.h"
*/
import "C"

// RbClass2Name calls `rb_class2name` in C
//
// Original definition is following
//
//	const char *rb_class2name(VALUE klass)
func RbClass2Name(klass VALUE) string {
	return char2String(C.rb_class2name(C.VALUE(klass)))
}
