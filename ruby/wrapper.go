package ruby

/*
#include "ruby.h"
*/
import "C"

import (
	"unsafe"
)

// String2Char convert from Go string to [*Char]
//
// 2nd return value is a function to free pointer.
// To prevent memory leaks, this function MUST always be called with `defer` when calling this function.
//
// Example
//
//	char, clean := ruby.String2Char("ABCD")
//	defer clean()
func String2Char(str string) (*Char, func()) {
	char, clean := string2Char(str)
	return (*Char)(char), clean
}

// string2Char convert from Go string to `*C.char`. (for internal use within package)
//
// 2nd return value is a function to free pointer.
// To prevent memory leaks, this function MUST always be called with `defer` when calling this function.
//
// Example
//
//	char, clean := string2Char("ABCD")
//	defer clean()
func string2Char(str string) (*C.char, func()) {
	// FIXME: https://www.slideshare.net/slideshow/ruby-meets-go/56074507#28
	//        recommends avoiding unnecessary copying of string.
	//        But current Go's string isn't a null-terminated string, so using `*(*[]byte)(unsafe.Pointer(&str))`
	//        will return a non-null-terminated byte array and can't be `*C.char`.
	//        Therefore, copying of byte arrays is unavoidable...
	cstr := C.CString(str)

	clean := func() {
		C.free(unsafe.Pointer(cstr))
	}

	return cstr, clean
}

// Char2String convert from [*Char] to Go string without copy
func Char2String(char *Char) string {
	return char2String((*C.char)(char))
}

// char2String convert from `*C.char` to Go string without copy. (for internal use within package)
func char2String(char *C.char) string {
	return unsafe.String((*byte)(unsafe.Pointer(char)), C.strlen(char))
}

// Value2String convert from [VALUE] to Go string
func Value2String(str VALUE) string {
	return value2String(C.VALUE(str))
}

// value2String convert from `C.VALUE` to Go string. (for internal use within package)
func value2String(str C.VALUE) string {
	return C.GoStringN(rstringPtr(str), rstringLenint(str))
}

// StringLen returns string length as [Long]
func StringLen(str string) Long {
	return Long(stringLen(str))
}

// stringLen returns string length as `C.long`. (for internal use within package)
func stringLen(str string) C.long {
	return C.long(len(str))
}

// String2Value convert from Go string to [VALUE]
func String2Value(str string) VALUE {
	return VALUE(string2Value(str))
}

// string2Value convert from Go string to `C.VALUE`. (for internal use within package)
func string2Value(str string) C.VALUE {
	if len(str) == 0 {
		return rbUtf8StrNew(nil, C.long(0))
	}

	char, clean := string2Char(str)
	defer clean()

	return rbUtf8StrNew(char, stringLen(str))
}

// toCPointer convert from `unsafe.Pointer` to C pointer without copy.
func toCPointer(ptr unsafe.Pointer) *[0]byte {
	return (*[0]byte)(ptr)
}

// toCArray converts a slice of any type to a C pointer without copy.
//
// Example
//
//	var values []VALUE
//	cValues := toCArray[VALUE, C.VALUE](values)
func toCArray[FROM any, TO any](values []FROM) *TO {
	if len(values) == 0 {
		return (*TO)(unsafe.Pointer(nil))
	}

	return (*TO)(unsafe.Pointer(&values[0]))
}

// toCValueArray convert from [][VALUE] to `*C.VALUE` without copy.
func toCValueArray(values []VALUE) *C.VALUE {
	if len(values) == 0 {
		return (*C.VALUE)(unsafe.Pointer(nil))
	}

	return (*C.VALUE)(unsafe.Pointer(&values[0]))
}

// CallFunction calls receiver's method. (wrapper for [RbFuncallv])
func CallFunction(receiver VALUE, methodName string, args ...VALUE) VALUE {
	return RbFuncallv(receiver, RbIntern(methodName), len(args), args)
}

// Bool2Int convert from bool to int (0 or 1)
func Bool2Int(b bool) int {
	if b {
		return 1
	}

	return 0
}

// Int2Bool convert from int (0 or 1) to bool
func Int2Bool(i Int) bool {
	return int2Bool(C.int(i))
}

// int2Bool convert from int (0 or 1) to bool. (for internal use within package)
func int2Bool(i C.int) bool {
	return i != 0
}

// Slice2rbAry convert from Go slice to rb_ary
func Slice2rbAry(slice []VALUE) VALUE {
	rbAry := RbAryNewCapa(int64(len(slice)))

	for _, v := range slice {
		RbAryPush(rbAry, v)
	}

	return rbAry
}
