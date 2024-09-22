// THE AUTOGENERATED LICENSE. ALL THE RIGHTS ARE RESERVED BY ROBOTS.

// WARNING: This file has automatically been generated
// Code generated by ruby_h_to_go. DO NOT EDIT.

package ruby

/*
#include "ruby.h"
*/
import "C"

import (
	"unsafe"
)

// RbRactorLocalKeyT is a type for passing `C.rb_ractor_local_key_t` in and out of package
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/ractor.h
type RbRactorLocalKeyT C.rb_ractor_local_key_t

// RbRactorLocalStorageType is a type for passing `C.rb_ractor_local_storage_type` in and out of package
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/ractor.h
type RbRactorLocalStorageType C.rb_ractor_local_storage_type

// RbRactorLocalStoragePtr calls `rb_ractor_local_storage_ptr` in C
//
// Original definition is following
//
//	void *rb_ractor_local_storage_ptr(rb_ractor_local_key_t key)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/ractor.h
func RbRactorLocalStoragePtr(key RbRactorLocalKeyT) unsafe.Pointer {
	ret := unsafe.Pointer(C.rb_ractor_local_storage_ptr(C.rb_ractor_local_key_t(key)))
	return ret
}

// RbRactorLocalStoragePtrNewkey calls `rb_ractor_local_storage_ptr_newkey` in C
//
// Original definition is following
//
//	rb_ractor_local_key_t rb_ractor_local_storage_ptr_newkey(const struct rb_ractor_local_storage_type *type)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/ractor.h
func RbRactorLocalStoragePtrNewkey(r *RbRactorLocalStorageType) RbRactorLocalKeyT {
	var cR C.rb_ractor_local_storage_type
	ret := RbRactorLocalKeyT(C.rb_ractor_local_storage_ptr_newkey(&cR))
	*r = RbRactorLocalStorageType(cR)
	return ret
}

// RbRactorLocalStoragePtrSet calls `rb_ractor_local_storage_ptr_set` in C
//
// Original definition is following
//
//	void  rb_ractor_local_storage_ptr_set(rb_ractor_local_key_t key, void *ptr)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/ractor.h
func RbRactorLocalStoragePtrSet(key RbRactorLocalKeyT, ptr unsafe.Pointer) {
	C.rb_ractor_local_storage_ptr_set(C.rb_ractor_local_key_t(key), toCPointer(ptr))
}

// RbRactorLocalStorageValue calls `rb_ractor_local_storage_value` in C
//
// Original definition is following
//
//	VALUE rb_ractor_local_storage_value(rb_ractor_local_key_t key)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/ractor.h
func RbRactorLocalStorageValue(key RbRactorLocalKeyT) VALUE {
	ret := VALUE(C.rb_ractor_local_storage_value(C.rb_ractor_local_key_t(key)))
	return ret
}

// RbRactorLocalStorageValueLookup calls `rb_ractor_local_storage_value_lookup` in C
//
// Original definition is following
//
//	bool rb_ractor_local_storage_value_lookup(rb_ractor_local_key_t key, VALUE *val)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/ractor.h
func RbRactorLocalStorageValueLookup(key RbRactorLocalKeyT, val *VALUE) Bool {
	var cVal C.VALUE
	ret := Bool(C.rb_ractor_local_storage_value_lookup(C.rb_ractor_local_key_t(key), &cVal))
	*val = VALUE(cVal)
	return ret
}

// RbRactorLocalStorageValueNewkey calls `rb_ractor_local_storage_value_newkey` in C
//
// Original definition is following
//
//	rb_ractor_local_key_t rb_ractor_local_storage_value_newkey(void)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/ractor.h
func RbRactorLocalStorageValueNewkey() RbRactorLocalKeyT {
	ret := RbRactorLocalKeyT(C.rb_ractor_local_storage_value_newkey())
	return ret
}

// RbRactorLocalStorageValueSet calls `rb_ractor_local_storage_value_set` in C
//
// Original definition is following
//
//	void  rb_ractor_local_storage_value_set(rb_ractor_local_key_t key, VALUE val)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/ractor.h
func RbRactorLocalStorageValueSet(key RbRactorLocalKeyT, val VALUE) {
	C.rb_ractor_local_storage_value_set(C.rb_ractor_local_key_t(key), C.VALUE(val))
}

// RbRactorMakeShareable calls `rb_ractor_make_shareable` in C
//
// Original definition is following
//
//	VALUE rb_ractor_make_shareable(VALUE obj)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/ractor.h
func RbRactorMakeShareable(obj VALUE) VALUE {
	ret := VALUE(C.rb_ractor_make_shareable(C.VALUE(obj)))
	return ret
}

// RbRactorMakeShareableCopy calls `rb_ractor_make_shareable_copy` in C
//
// Original definition is following
//
//	VALUE rb_ractor_make_shareable_copy(VALUE obj)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/ractor.h
func RbRactorMakeShareableCopy(obj VALUE) VALUE {
	ret := VALUE(C.rb_ractor_make_shareable_copy(C.VALUE(obj)))
	return ret
}

// RbRactorStderr calls `rb_ractor_stderr` in C
//
// Original definition is following
//
//	VALUE rb_ractor_stderr(void)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/ractor.h
func RbRactorStderr() VALUE {
	ret := VALUE(C.rb_ractor_stderr())
	return ret
}

// RbRactorStderrSet calls `rb_ractor_stderr_set` in C
//
// Original definition is following
//
//	void rb_ractor_stderr_set(VALUE io)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/ractor.h
func RbRactorStderrSet(io VALUE) {
	C.rb_ractor_stderr_set(C.VALUE(io))
}

// RbRactorStdin calls `rb_ractor_stdin` in C
//
// Original definition is following
//
//	VALUE rb_ractor_stdin(void)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/ractor.h
func RbRactorStdin() VALUE {
	ret := VALUE(C.rb_ractor_stdin())
	return ret
}

// RbRactorStdinSet calls `rb_ractor_stdin_set` in C
//
// Original definition is following
//
//	void rb_ractor_stdin_set(VALUE io)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/ractor.h
func RbRactorStdinSet(io VALUE) {
	C.rb_ractor_stdin_set(C.VALUE(io))
}

// RbRactorStdout calls `rb_ractor_stdout` in C
//
// Original definition is following
//
//	VALUE rb_ractor_stdout(void)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/ractor.h
func RbRactorStdout() VALUE {
	ret := VALUE(C.rb_ractor_stdout())
	return ret
}

// RbRactorStdoutSet calls `rb_ractor_stdout_set` in C
//
// Original definition is following
//
//	void rb_ractor_stdout_set(VALUE io)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/ractor.h
func RbRactorStdoutSet(io VALUE) {
	C.rb_ractor_stdout_set(C.VALUE(io))
}
