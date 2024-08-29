package ruby

/*
#include "ruby.h"
*/
import "C"

// c.f. https://github.com/ruby/ruby/blob/master/include/ruby/internal/special_consts.h

// Qtrue returns `Qtrue` in C
func Qtrue() VALUE {
	return VALUE(C.Qtrue)
}

// Qfalse returns `Qfalse` in C
func Qfalse() VALUE {
	return VALUE(C.Qfalse)
}
