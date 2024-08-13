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
	return VALUE(C.rb_funcallv(C.VALUE(recv), C.ID(mid), C.int(argc), toCValueArray(argv)))
}

// RbFuncall2 is alias to [RbFuncallv]
func RbFuncall2(recv VALUE, mid ID, argc int, argv []VALUE) VALUE {
	return RbFuncallv(recv, mid, argc, argv)
}

// RbFuncallvPublic calls `rb_funcallv_public` in C
//
// Original definition is following
//
//	VALUE rb_funcallv_public(VALUE recv, ID mid, int argc, const VALUE *argv)
func RbFuncallvPublic(recv VALUE, mid ID, argc int, argv []VALUE) VALUE {
	return VALUE(C.rb_funcallv_public(C.VALUE(recv), C.ID(mid), C.int(argc), toCValueArray(argv)))
}

// RbFuncall3 is alias to [RbFuncallvPublic]
func RbFuncall3(recv VALUE, mid ID, argc int, argv []VALUE) VALUE {
	return RbFuncallvPublic(recv, mid, argc, argv)
}

// RbEvalString calls `rb_eval_string` in C
//
// Original definition is following
//
//	VALUE rb_eval_string(const char *str)
func RbEvalString(str string) VALUE {
	char, clean := string2Char(str)
	defer clean()

	return VALUE(C.rb_eval_string(char))
}

// RbEvalStringProtect calls `rb_eval_string_protect` in C
//
// Original definition is following
//
//	VALUE rb_eval_string_protect(const char *str, int *state)
func RbEvalStringProtect(str string, state *Int) VALUE {
	char, clean := string2Char(str)
	defer clean()

	var cState C.int
	ret := C.rb_eval_string_protect(char, (*C.int)(unsafe.Pointer(&cState)))
	*state = Int(cState)

	return VALUE(ret)
}

// RbEvalStringWrap calls `rb_eval_string_wrap` in C
//
// Original definition is following
//
//	VALUE rb_eval_string_wrap(const char *str, int *state)
func RbEvalStringWrap(str string, state *Int) VALUE {
	char, clean := string2Char(str)
	defer clean()

	var cState C.int
	ret := C.rb_eval_string_wrap(char, (*C.int)(unsafe.Pointer(&cState)))
	*state = Int(cState)

	return VALUE(ret)
}
