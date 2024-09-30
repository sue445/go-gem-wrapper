package ruby

/*
#include "ruby.h"
*/
import "C"

// c.f. https://github.com/ruby/ruby/blob/master/include/ruby/internal/intern/array.h

// RbAryNew2 is alias to [RbAryNewCapa]
func RbAryNew2(capa Long) VALUE {
	return RbAryNewCapa(capa)
}
