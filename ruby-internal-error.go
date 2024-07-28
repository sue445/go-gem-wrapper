package ruby

/*
#include "ruby.h"

// Because variable length arguments cannot be passed from Go to C
void
rb_raise2(VALUE exception, const char *str) {
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
	C.rb_raise2(C.VALUE(exc), string2Char(str))
}
