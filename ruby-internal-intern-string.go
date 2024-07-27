package ruby

/*
#include "ruby.h"
*/
import "C"

// c.f. https://github.com/ruby/ruby/blob/master/include/ruby/internal/intern/string.h

// RbUtf8StrNew calls `rb_utf8_str_new` in C
//
// Original definition is following
//
//	VALUE rb_utf8_str_new(const char *ptr, long len)
func RbUtf8StrNew(str *Char, len Long) VALUE {
	return VALUE(rbUtf8StrNew((*C.char)(str), C.long(len)))
}

// rbUtf8StrNew calls `rb_utf8_str_new` in C. (for internal use within package)
//
// Original definition is following
//
//	VALUE rb_utf8_str_new(const char *ptr, long len)
func rbUtf8StrNew(str *C.char, len C.long) C.VALUE {
	return C.rb_utf8_str_new(str, len)
}
