package ruby

/*
#include "ruby.h"
*/
import "C"

// Char is a type for passing `C.char` in and out of package
type Char C.char

// Uchar is a type for passing `C.uchar` in and out of package
type Uchar C.uchar

// Long is a type for passing `C.long` in and out of package
type Long C.long

// Int is a type for passing `C.int` in and out of package
type Int C.int

// Double is a type for passing `C.double` in and out of package
type Double C.double

// Short is a type for passing `C.short` in and out of package
type Short C.short

// Ushort is a type for passing `C.ushort` in and out of package
type Ushort C.ushort

// Longlong is a type for passing `C.longlong` in and out of package
type Longlong C.longlong

// Ulonglong is a type for passing `C.ulonglong` in and out of package
type Ulonglong C.ulonglong

// IntptrT is a type for passing `C.intptr_t` in and out of package
type IntptrT C.intptr_t

// Uint32T is a type for passing `C.uint32_t` in and out of package
type Uint32T C.uint32_t

// UintptrT is a type for passing `C.uintptr_t` in and out of package
type UintptrT C.uintptr_t

// SizeT is a type for passing `C.size_t` in and out of package
type SizeT C.size_t

// SsizeT is a type for passing `C.ssize_t` in and out of package
type SsizeT C.ssize_t

// TimeT is a type for passing `C.time_t` in and out of package
type TimeT C.time_t

// VaList is a type for passing `C.va_list` in and out of package
type VaList C.va_list

// FdSet is a type for passing `C.fd_set` in and out of package
type FdSet C.fd_set

// ModeT is a type for passing `C.mode_t` in and out of package
type ModeT C.mode_t

// Void is a type for passing `C.void` in and out of package
type Void C.void

// Bool is a type for passing `C.bool` in and out of package
type Bool C.bool

// IsTrue checks whether true
func (b Bool) IsTrue() bool {
	return C.bool(b) == C.bool(true)
}

// IsFalse checks whether false
func (b Bool) IsFalse() bool {
	return C.bool(b) == C.bool(false)
}
