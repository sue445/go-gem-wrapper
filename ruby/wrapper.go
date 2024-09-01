package ruby

/*
#include "ruby.h"
*/
import "C"
import (
	"unsafe"
)

// Value2String convert from [VALUE] to Go string
func Value2String(str VALUE) string {
	return C.GoStringN(byte2Cchar(RSTRING_PTR(str)), C.int(RSTRING_LENINT(str)))
}

// byte2Cchar convert from `*byte` to `*C.char`
func byte2Cchar(b *byte) *C.char {
	return (*C.char)(unsafe.Pointer(b))
}

// String2Value convert from Go string to [VALUE]
func String2Value(str string) VALUE {
	return VALUE(string2Value(str))
}

// string2Value convert from Go string to `C.VALUE`. (for internal use within package)
func string2Value(str string) C.VALUE {
	return RbUtf8StrNew(str, int64(len(str)))
}

// CallFunction calls receiver's method. (wrapper for [RbFuncallv])
func CallFunction(receiver VALUE, methodName string, args ...VALUE) VALUE {
	return RbFuncallv(receiver, RbIntern(methodName), int32(len(args)), args)
}

// Slice2rbAry convert from Go slice to rb_ary
func Slice2rbAry(slice []VALUE) VALUE {
	rbAry := RbAryNewCapa(int64(len(slice)))

	for _, v := range slice {
		RbAryPush(rbAry, v)
	}

	return rbAry
}
