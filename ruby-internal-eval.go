package ruby

/*
#include "ruby.h"
*/
import "C"

import (
	"unsafe"
)

// c.f. https://github.com/ruby/ruby/blob/master/include/ruby/internal/eval.h

// RbFuncallv calls `rb_funcallv` in C
//
// Original definition is following
//
//	VALUE rb_funcallv(VALUE recv, ID mid, int argc, const VALUE *argv)
func RbFuncallv(recv VALUE, mid ID, argc int, argv []VALUE) VALUE {
	var cArgs *C.VALUE
	if argc == 0 {
		cArgs = (*C.VALUE)(unsafe.Pointer(nil))
	} else {
		cArgs = (*C.VALUE)(unsafe.Pointer(&argv[0]))
	}

	return VALUE(C.rb_funcallv(C.VALUE(recv), C.ID(mid), C.int(argc), cArgs))
}

// RbFuncall2 is alias to [RbFuncallv]
func RbFuncall2(recv VALUE, mid ID, argc int, argv []VALUE) VALUE {
	return RbFuncallv(recv, mid, argc, argv)
}
