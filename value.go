package ruby

/*
#include "ruby.h"
*/
import "C"

// c.f. https://github.com/ruby/ruby/blob/master/include/ruby/internal/value.h

// VALUE represents `VALUE` in C
type VALUE C.VALUE
