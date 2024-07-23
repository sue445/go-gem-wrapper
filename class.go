package ruby

/*
#include "ruby.h"
*/
import "C"

import (
	"unsafe"
)

// RbDefineModule calls `rb_define_module` in C
func RbDefineModule(name string) VALUE {
	return VALUE(C.rb_define_module(goString2Char(name)))
}

// RbDefineSingletonMethod calls `rb_define_singleton_method` in C
func RbDefineSingletonMethod(klass VALUE, name string, fun unsafe.Pointer, args int) {
	cname := goString2Char(name)
	C.rb_define_singleton_method(C.VALUE(klass), cname, (*[0]byte)(fun), C.int(args))
}
