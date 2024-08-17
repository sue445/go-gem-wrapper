package main

/*
#include "dummy.h"

VALUE go_struct_alloc(VALUE klass);
*/
import "C"

import (
	ruby "github.com/sue445/go-gem-wrapper"
	"unsafe"
)

// GoStruct is internal reality of Ruby `Dummy::GoStruct`
type GoStruct struct {
	x int
	y int
}

//export go_struct_alloc
func go_struct_alloc(klass C.VALUE) C.VALUE {
	data := GoStruct{}
	return C.VALUE(ruby.NewGoStruct(ruby.VALUE(klass), unsafe.Pointer(&data)))
}

// defineMethodsToDummyGoStruct define methods in Dummy::GoStruct
func defineMethodsToDummyGoStruct(rb_mDummy ruby.VALUE) {
	// Create Dummy::GoStruct class
	rb_cGoStruct := ruby.RbDefineClassUnder(rb_mDummy, "GoStruct", ruby.VALUE(C.rb_cObject))

	ruby.RbDefineAllocFunc(rb_cGoStruct, C.go_struct_alloc)
}
