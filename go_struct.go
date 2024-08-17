package ruby

/*
#include "ruby.h"
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
