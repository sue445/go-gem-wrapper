package ruby

/*
#include "ruby.h"

// Go's variable-length arguments couldn't be passed directly to C, so they are passed through another function to avoid this
void __rb_raise(VALUE exception, const char *str) {
    rb_raise(exception, "%s", str);
}
*/
import "C"

import (
	"fmt"
)

// c.f. https://github.com/ruby/ruby/blob/master/include/ruby/internal/error.h

// RbRaise calls `rb_raise` in C
//
// Original definition is following
//
//	void rb_raise(VALUE exc, const char *fmt, ...)
//
// `format` is supported in [Go's format], not Ruby
//
// [Go's format]: https://pkg.go.dev/fmt
func RbRaise(exc VALUE, format string, a ...interface{}) {
	str := fmt.Sprintf(format, a...)
	strChar, strCharClean := string2Char(str)
	defer strCharClean()

	C.__rb_raise(C.VALUE(exc), strChar)
}
