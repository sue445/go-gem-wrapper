package ruby

/*
#include "ruby.h"
*/
import "C"

// c.f. https://github.com/ruby/ruby/blob/master/include/ruby/internal/value.h

// VALUE is a type for passing `C.VALUE` in and out of package
type VALUE C.VALUE
