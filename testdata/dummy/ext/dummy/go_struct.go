package main

/*
#include "dummy.h"

VALUE go_struct_alloc(VALUE klass);
void  rb_dummy_go_struct_set(VALUE self, VALUE x, VALUE y);
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

//export rb_dummy_go_struct_set
func rb_dummy_go_struct_set(self C.VALUE, x C.VALUE, y C.VALUE) {
	data := (*GoStruct)(ruby.GetGoStruct(ruby.VALUE(self)))
	data.x = int(ruby.NUM2INT(ruby.VALUE(x)))
	data.y = int(ruby.NUM2INT(ruby.VALUE(y)))
}

// defineMethodsToDummyGoStruct define methods in Dummy::GoStruct
func defineMethodsToDummyGoStruct(rb_mDummy ruby.VALUE) {
	// Create Dummy::GoStruct class
	rb_cGoStruct := ruby.RbDefineClassUnder(rb_mDummy, "GoStruct", ruby.VALUE(C.rb_cObject))

	ruby.RbDefineAllocFunc(rb_cGoStruct, C.go_struct_alloc)

	ruby.RbDefineMethod(rb_cGoStruct, "set", C.rb_dummy_go_struct_set, 2)
}
