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

// Double is a type for passing `C.double` in and out of package
type Double C.double

// Short is a type for passing `C.short` in and out of package
type Short C.short

// IntptrT is a type for passing `C.intptr_t` in and out of package
type IntptrT C.intptr_t

// Uint32T is a type for passing `C.uint32_t` in and out of package
type Uint32T C.uint32_t

// UintptrT is a type for passing `C.uintptr_t` in and out of package
type UintptrT C.uintptr_t

// SizeT is a type for passing `C.size_t` in and out of package
type SizeT C.size_t
