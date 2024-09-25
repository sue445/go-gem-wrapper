package ruby

/*
#include "ruby.h"
*/
import "C"

// c.f. https://github.com/ruby/ruby/blob/master/include/ruby/internal/intern/string.h

// rbUtf8StrNew calls `rb_utf8_str_new` in C. (for internal use within package)
//
// Original definition is following
//
//	VALUE rb_utf8_str_new(const char *ptr, long len)
func rbUtf8StrNew(str *C.char, len C.long) C.VALUE {
	return C.rb_utf8_str_new(str, len)
}
