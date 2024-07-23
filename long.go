package ruby

/*
#include "ruby.h"
*/
import "C"

// RbNum2long calls `rb_num2long` in C
func RbNum2long(n VALUE) Long {
	return Long(C.rb_num2long(C.VALUE(n)))
}

// RbLong2numInline calls `rb_long2num_inline` in C
func RbLong2numInline(n Long) VALUE {
	return VALUE(C.rb_long2num_inline(C.long(n)))
}
