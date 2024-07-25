package ruby

/*
#include "ruby.h"
*/
import "C"

// Char is a type for passing `C.char` in and out of package
type Char C.char

// Long is a type for passing `C.long` in and out of package
type Long C.long

// Int is a type for passing `C.int` in and out of package
type Int C.int
