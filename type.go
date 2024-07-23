package ruby

/*
#include "ruby.h"
*/
import "C"

// Char represents `char` in C
type Char C.char

// Long represents `long` in C
type Long C.long

// VALUE represents `VALUE` in C
type VALUE C.VALUE
