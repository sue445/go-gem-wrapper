package ruby

/*
#include "ruby.h"
*/
import "C"

// c.f. https://github.com/ruby/ruby/blob/master/include/ruby/internal/arithmetic/long.h

// NUM2LONG is alias to [RbNum2long]
func NUM2LONG(num VALUE) Long {
	return RbNum2Long(num)
}

// LONG2NUM is alias to [RbLong2numInline]
func LONG2NUM(v Long) VALUE {
	return RbLong2NumInline(v)
}
