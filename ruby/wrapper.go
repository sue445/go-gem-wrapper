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
	return RbUtf8StrNew(str, int64(len(str)))
}

// toFunctionPointer returns a pointer to function without copy.
func toFunctionPointer(fun unsafe.Pointer) *[0]byte {
	return (*[0]byte)(fun)
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
