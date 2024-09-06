package ruby

/*
#include "ruby.h"
#include <stdlib.h>
#include "cgo_helpers.h"

// Go's variable-length arguments couldn't be passed directly to C, so they are passed through another function to avoid this
void __rb_raise(VALUE exception, const char *str) {
    rb_raise(exception, "%s", str);
}
*/
import "C"

import (
	"fmt"
	"runtime"
)

// RbRaise function as declared in https://github.com/ruby/ruby/blob/master/include/ruby/internal/error.h
func RbRaise(exc VALUE, format string, a ...interface{}) {
	str := fmt.Sprintf(format, a...)
	cexc, cexcAllocMap := (C.VALUE)(exc), cgoAllocsUnknown
	cstr, cfmtAllocMap := unpackPCharString(str)
	C.__rb_raise(cexc, cstr)
	runtime.KeepAlive(str)
	runtime.KeepAlive(format)
	runtime.KeepAlive(cfmtAllocMap)
	runtime.KeepAlive(cexcAllocMap)
}
