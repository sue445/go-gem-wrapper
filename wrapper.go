package ruby

/*
#include "ruby.h"
*/
import "C"

import (
	"unsafe"
)

func string2Char(str string) *C.char {
	bytes := append([]byte(str), '\000')

	return (*C.char)(unsafe.Pointer(&bytes[0]))
}

// String2Char convert from Go string to `C.char`
func String2Char(str string) *Char {
	return (*Char)(string2Char(str))
}
