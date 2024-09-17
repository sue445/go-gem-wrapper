package ruby

/*
#include "ruby.h"
*/
import "C"

// FIXME: Following were not automatically generated because they were not included in ruby.h

// RbOffT is a type for passing `C.rb_off_t` in and out of package
type RbOffT C.rb_off_t

// RbPidT is a type for passing `C.rb_pid_t` in and out of package
type RbPidT C.rb_pid_t
