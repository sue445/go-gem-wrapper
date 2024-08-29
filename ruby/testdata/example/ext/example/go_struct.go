package main

/*
#include "example.h"

VALUE go_struct_alloc(VALUE klass);
void  rb_example_go_struct_set(VALUE self, VALUE x, VALUE y);
VALUE rb_example_go_struct_get(VALUE self);
*/
import "C"

import (
	"github.com/sue445/go-gem-wrapper/ruby"
	"unsafe"
)

// GoStruct is internal reality of Ruby `Example::GoStruct`
type GoStruct struct {
	x int
	y int
}

//export go_struct_alloc
func go_struct_alloc(klass C.VALUE) C.VALUE {
	data := GoStruct{}
	return C.VALUE(ruby.NewGoStruct(ruby.VALUE(klass), unsafe.Pointer(&data)))
}

//export rb_example_go_struct_set
func rb_example_go_struct_set(self C.VALUE, x C.VALUE, y C.VALUE) {
	data := (*GoStruct)(ruby.GetGoStruct(ruby.VALUE(self)))
	data.x = int(ruby.NUM2INT(ruby.VALUE(x)))
	data.y = int(ruby.NUM2INT(ruby.VALUE(y)))
}

//export rb_example_go_struct_get
func rb_example_go_struct_get(self C.VALUE) C.VALUE {
	data := (*GoStruct)(ruby.GetGoStruct(ruby.VALUE(self)))

	ret := []ruby.VALUE{
		ruby.INT2NUM(int32(data.x)),
		ruby.INT2NUM(int32(data.y)),
	}

	return C.VALUE(ruby.Slice2rbAry(ret))
}

// defineMethodsToExampleGoStruct define methods in Example::GoStruct
func defineMethodsToExampleGoStruct(rb_mExample ruby.VALUE) {
	// Create Example::GoStruct class
	rb_cGoStruct := ruby.RbDefineClassUnder(rb_mExample, "GoStruct", ruby.VALUE(C.rb_cObject))

	ruby.RbDefineAllocFunc(rb_cGoStruct, C.go_struct_alloc)

	ruby.RbDefineMethod(rb_cGoStruct, "set", C.rb_example_go_struct_set, 2)
	ruby.RbDefineMethod(rb_cGoStruct, "get", C.rb_example_go_struct_get, 0)
}
