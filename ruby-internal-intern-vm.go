package ruby

/*
#include "ruby.h"
*/
import "C"

import (
	"unsafe"
)

// RbAlias calls `rb_alias` in C
//
// Original definition is following
//
//	void rb_alias(VALUE klass, ID dst, ID src)
func RbAlias(klass VALUE, dst ID, src ID) {
	C.rb_alias(C.VALUE(klass), C.ID(dst), C.ID(src))
}

// RbAttr calls `rb_attr` in C
//
// Original definition is following
//
//	void rb_attr(VALUE klass, ID name, int need_reader, int need_writer, int honour_visibility)
func RbAttr(klass VALUE, name ID, needReader bool, needWriter bool, honourVisibility bool) {
	C.rb_attr(C.VALUE(klass), C.ID(name), C.int(Bool2Int(needReader)), C.int(Bool2Int(needWriter)), C.int(Bool2Int(honourVisibility)))
}

// RbDefineAllocFunc calls `rb_define_alloc_func` in C
//
// Original definition is following
//
//	void rb_define_alloc_func(VALUE klass, rb_alloc_func_t func)
//
// Example
//
//	/*
//	package main
//
//	#include "example.h"
//
//	VALUE go_struct_alloc(VALUE klass);
//	*/
//	import "C"
//
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
//	//export Init_example
//	func Init_example() {
//		rb_mExample := ruby.RbDefineModule("Example")
//
//		// Create Example::GoStruct class
//		rb_cGoStruct := ruby.RbDefineClassUnder(rb_mExample, "GoStruct", ruby.VALUE(C.rb_cObject))
//
//		ruby.RbDefineAllocFunc(rb_cGoStruct, C.go_struct_alloc)
//	}
func RbDefineAllocFunc(klass VALUE, fun unsafe.Pointer) {
	C.rb_define_alloc_func(C.VALUE(klass), toFunctionPointer(fun))
}
