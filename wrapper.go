package ruby

/*
#include "ruby.h"
*/
import "C"

import (
	"unsafe"
)

func goString2Char(str string) *C.char {
	bytes := append([]byte(str), '\000')

	return (*C.char)(unsafe.Pointer(&bytes[0]))
}

// GoString2Char convert from Go string to `C.char`
func GoString2Char(str string) *Char {
	return (*Char)(goString2Char(str))
}
