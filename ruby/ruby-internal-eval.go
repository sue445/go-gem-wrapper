package ruby

/*
#include "ruby.h"
*/
import "C"

// c.f. https://github.com/ruby/ruby/blob/master/include/ruby/internal/eval.h

// RbFuncall2 is alias to [RbFuncallv]
func RbFuncall2(recv VALUE, mid ID, argc int, argv []VALUE) VALUE {
	return RbFuncallv(recv, mid, argc, argv)
}

// RbFuncall3 is alias to [RbFuncallvPublic]
func RbFuncall3(recv VALUE, mid ID, argc int, argv []VALUE) VALUE {
	return RbFuncallvPublic(recv, mid, argc, argv)
}
