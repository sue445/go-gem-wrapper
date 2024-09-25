package ruby

/*
#include "ruby.h"
*/
import "C"

// c.f. https://github.com/ruby/ruby/blob/master/include/ruby/internal/arithmetic/int.h

// NUM2INT is alias to [RbNum2intInline]
func NUM2INT(x VALUE) Int {
	return RbNum2IntInline(x)
}

// INT2NUM is alias to [RbInt2numInline]
func INT2NUM(v Int) VALUE {
	return RbInt2NumInline(v)
}
