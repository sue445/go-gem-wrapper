package ruby

/*
#include "ruby.h"
*/
import "C"

// c.f. https://github.com/ruby/ruby/blob/master/include/ruby/internal/core/rstring.h

// RstringPtr calls `RSTRING_PTR` in C
func RstringPtr(str VALUE) *Char {
	return (*Char)(rstringPtr(C.VALUE(str)))
}

// rstringPtr calls `RSTRING_PTR` in C
func rstringPtr(str C.VALUE) *C.char {
	return C.RSTRING_PTR(str)
}

// RstringLenint calls `RSTRING_LENINT` in C
func RstringLenint(str VALUE) Int {
	return Int(rstringLenint(C.VALUE(str)))
}

// rstringLenint calls `RSTRING_LENINT` in C
func rstringLenint(str C.VALUE) C.int {
	return C.RSTRING_LENINT(str)
}
