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
func RbRaise(exc VALUE, format string, a ...interface{}) {
	str := fmt.Sprintf(format, a...)
	C.rb_raise2(C.VALUE(exc), goString2Char(str))
}
