package ruby

/*
#include "ruby.h"
*/
import "C"

// StructTimeval is a type for passing `C.struct_timeval` in and out of package
type StructTimeval C.struct_timeval

// Timeval is alias to [StructTimeval]
type Timeval StructTimeval

// StructTimespec is a type for passing `C.struct_timespec` in and out of package
type StructTimespec C.struct_timespec

// Timespec is alias to [StructTimespec]
type Timespec StructTimespec
