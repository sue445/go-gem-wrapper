package ruby

/*
#include "ruby.h"
*/
import "C"

import (
	"unsafe"
)

// String2Char convert from Go string to `*Char`
func String2Char(str string) *Char {
	return (*Char)(string2Char(str))
}

// string2Char convert from Go string to `*C.char`. (for internal use within package)
func string2Char(str string) *C.char {
	// FIXME: Go's string isn't a null-terminated string, so using `*(*[]byte)(unsafe.Pointer(&str))`
	//        will return a non-null-terminated byte array and can't be `*C.char`.
	//        Therefore, copying of byte arrays is unavoidable,
	//        so a slice is created that minimizes `len` and `cap` with null-terminations included
	bytes := make([]byte, len(str)+1)
	copy(bytes, str)

	return (*C.char)(unsafe.Pointer(&bytes[0]))
}

// Value2String convert from `VALUE` to Go string
func Value2String(str VALUE) string {
	return value2String(C.VALUE(str))
}

// value2String convert from `C.VALUE` to Go string. (for internal use within package)
func value2String(str C.VALUE) string {
	return C.GoStringN(rstringPtr(str), rstringLenint(str))
}

// StringLen returns string length as `Long`
func StringLen(str string) Long {
	return Long(stringLen(str))
}

// stringLen returns string length as `C.long`. (for internal use within package)
func stringLen(str string) C.long {
	return C.long(len(str))
}

// String2Value convert from Go string to `VALUE`
func String2Value(str string) VALUE {
	return VALUE(string2Value(str))
}

// string2Value convert from Go string to `C.VALUE`. (for internal use within package)
func string2Value(str string) C.VALUE {
	if len(str) == 0 {
		return rbUtf8StrNew(nil, C.long(0))
	}
	return rbUtf8StrNew(string2Char(str), stringLen(str))
}

// toFunctionPointer returns a pointer to function. (for internal use within package)
func toFunctionPointer(fun unsafe.Pointer) *[0]byte {
	return (*[0]byte)(fun)
}

// toCValueArray convert from `[]ruby.VALUE` to `*C.VALUE`. (for internal use within package)
func toCValueArray(values []VALUE) *C.VALUE {
	if len(values) == 0 {
		return (*C.VALUE)(unsafe.Pointer(nil))
	}

	return (*C.VALUE)(unsafe.Pointer(&values[0]))
}
