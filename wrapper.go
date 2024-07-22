package ruby

/*
#include "ruby.h"
*/
import "C"

import (
	"unsafe"
)

type VALUE C.VALUE

func GOSTRING_PTR(str string) *C.char {
	bytes := append([]byte(str), '\000')

	return (*C.char)(unsafe.Pointer(&bytes[0]))
}

func RbDefineModule(name string) VALUE {
	return (VALUE)(C.rb_define_module(GOSTRING_PTR(name)))
}
