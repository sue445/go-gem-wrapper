package ruby

/*
#include "ruby.h"
*/
import "C"

func rbNum2long(n C.VALUE) C.long {
	return C.rb_num2long(n)
}

// RbNum2long calls `rb_num2long` in C
func RbNum2long(n VALUE) Long {
	return Long(rbNum2long(C.VALUE(n)))
}

func rbLong2numInline(n C.long) C.VALUE {
	return C.rb_long2num_inline(n)
}

// RbLong2numInline calls `rb_long2num_inline` in C
func RbLong2numInline(n Long) VALUE {
	return VALUE(rbLong2numInline(C.long(n)))
}
