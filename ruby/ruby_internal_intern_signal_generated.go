// THE AUTOGENERATED LICENSE. ALL THE RIGHTS ARE RESERVED BY ROBOTS.

// WARNING: This file has automatically been generated
// Code generated by ruby_h_to_go. DO NOT EDIT.

package ruby

/*
#include "ruby.h"
*/
import "C"

// RbFKill calls `rb_f_kill` in C
//
// Original definition is following
//
//	VALUE rb_f_kill(int argc, const VALUE *argv)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/intern/signal.h
func RbFKill(argc int, argv *VALUE) VALUE {
	var cArgv C.VALUE
	ret := VALUE(C.rb_f_kill(C.int(argc), &cArgv))
	*argv = VALUE(cArgv)
	return ret
}
