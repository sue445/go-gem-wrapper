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
func NewGoStruct(klass VALUE, goobj unsafe.Pointer) VALUE {
	return VALUE(C.NewGoStruct(C.VALUE(klass), goobj))
}

// GetGoStruct returns Go object from Ruby object
func GetGoStruct(obj VALUE) unsafe.Pointer {
	return C.GetGoStruct(C.VALUE(obj))
}
