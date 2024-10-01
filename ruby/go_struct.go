package ruby

/*
#include "ruby.h"

VALUE NewGoStruct(VALUE klass, void *p);
void* GetGoStruct(VALUE obj);
*/
import "C"

import (
	"unsafe"
)

var objects = make(map[interface{}]int)

//export goobj_retain
func goobj_retain(obj unsafe.Pointer) {
	objects[obj]++
}

//export goobj_free
func goobj_free(obj unsafe.Pointer) {
	objects[obj]--
	if objects[obj] <= 0 {
		delete(objects, obj)
	}
}

// NewGoStruct create Ruby object from Go object
//
// Example
//
//	/*
//	package main
//
//	#include "example.h"
//
//	VALUE go_struct_alloc(VALUE klass);
//	void  rb_example_go_struct_set(VALUE self, VALUE x, VALUE y);
//	VALUE rb_example_go_struct_get(VALUE self);
//	*/
//	import "C"
//
//	import (
//		"github.com/sue445/go-gem-wrapper/ruby"
//		"unsafe"
//	)
//
//	// GoStruct is internal reality of Ruby `Example::GoStruct`
//	type GoStruct struct {
//		x int
//		y int
//	}
//
//	//export go_struct_alloc
//	func go_struct_alloc(klass C.VALUE) C.VALUE {
//		data := GoStruct{}
//		return C.VALUE(ruby.NewGoStruct(ruby.VALUE(klass), unsafe.Pointer(&data)))
//	}
//
//	//export rb_example_go_struct_set
//	func rb_example_go_struct_set(self C.VALUE, x C.VALUE, y C.VALUE) {
//		data := (*GoStruct)(ruby.GetGoStruct(ruby.VALUE(self)))
//		data.x = ruby.NUM2INT(ruby.VALUE(x))
//		data.y = ruby.NUM2INT(ruby.VALUE(y))
//	}
//
//	//export rb_example_go_struct_get
//	func rb_example_go_struct_get(self C.VALUE) C.VALUE {
//		data := (*GoStruct)(ruby.GetGoStruct(ruby.VALUE(self)))
//
//		ret := []ruby.VALUE{
//			ruby.INT2NUM(data.x),
//			ruby.INT2NUM(data.y),
//		}
//
//		return C.VALUE(ruby.Slice2rbAry(ret))
//	}
//
//	//export Init_example
//	func Init_example() {
//		rb_mExample := ruby.RbDefineModule("Example")
//
//		// Create Example::GoStruct class
//		rb_cGoStruct := ruby.RbDefineClassUnder(rb_mExample, "GoStruct", ruby.VALUE(C.rb_cObject))
//
//		ruby.RbDefineAllocFunc(rb_cGoStruct, C.go_struct_alloc)
//
//		ruby.RbDefineMethod(rb_cGoStruct, "set", C.rb_example_go_struct_set, 2)
//		ruby.RbDefineMethod(rb_cGoStruct, "get", C.rb_example_go_struct_get, 0)
//	}
func NewGoStruct(klass VALUE, goobj unsafe.Pointer) VALUE {
	return VALUE(C.NewGoStruct(C.VALUE(klass), goobj))
}

// GetGoStruct returns Go object from Ruby object
//
// See also [NewGoStruct]
func GetGoStruct(obj VALUE) unsafe.Pointer {
	return C.GetGoStruct(C.VALUE(obj))
}
