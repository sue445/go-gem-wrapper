// THE AUTOGENERATED LICENSE. ALL THE RIGHTS ARE RESERVED BY ROBOTS.

// WARNING: This file has automatically been generated
// Code generated by ruby_h_to_go. DO NOT EDIT.

package ruby

/*
#include "ruby.h"
*/
import "C"

// RbFdsetT is a type for passing `C.rb_fdset_t` in and out of package
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/intern/select/largesize.h
type RbFdsetT C.rb_fdset_t

// RbFdClr calls `rb_fd_clr` in C
//
// Original definition is following
//
//	void rb_fd_clr(int fd, rb_fdset_t *f)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/intern/select/largesize.h
func RbFdClr(fd int, f *RbFdsetT) {
	var cF C.rb_fdset_t
	C.rb_fd_clr(C.int(fd), &cF)
	*f = RbFdsetT(cF)
}

// RbFdCopy calls `rb_fd_copy` in C
//
// Original definition is following
//
//	void rb_fd_copy(rb_fdset_t *dst, const fd_set *src, int max)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/intern/select/largesize.h
func RbFdCopy(dst *RbFdsetT, src *FdSet, max int) {
	var cDst C.rb_fdset_t
	var cSrc C.fd_set
	C.rb_fd_copy(&cDst, &cSrc, C.int(max))
	*dst = RbFdsetT(cDst)
	*src = FdSet(cSrc)
}

// RbFdDup calls `rb_fd_dup` in C
//
// Original definition is following
//
//	void rb_fd_dup(rb_fdset_t *dst, const rb_fdset_t *src)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/intern/select/largesize.h
func RbFdDup(dst *RbFdsetT, src *RbFdsetT) {
	var cDst C.rb_fdset_t
	var cSrc C.rb_fdset_t
	C.rb_fd_dup(&cDst, &cSrc)
	*dst = RbFdsetT(cDst)
	*src = RbFdsetT(cSrc)
}

// RbFdInit calls `rb_fd_init` in C
//
// Original definition is following
//
//	void rb_fd_init(rb_fdset_t *f)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/intern/select/largesize.h
func RbFdInit(f *RbFdsetT) {
	var cF C.rb_fdset_t
	C.rb_fd_init(&cF)
	*f = RbFdsetT(cF)
}

// RbFdSet calls `rb_fd_set` in C
//
// Original definition is following
//
//	void rb_fd_set(int fd, rb_fdset_t *f)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/intern/select/largesize.h
func RbFdSet(fd int, f *RbFdsetT) {
	var cF C.rb_fdset_t
	C.rb_fd_set(C.int(fd), &cF)
	*f = RbFdsetT(cF)
}

// RbFdTerm calls `rb_fd_term` in C
//
// Original definition is following
//
//	void rb_fd_term(rb_fdset_t *f)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/intern/select/largesize.h
func RbFdTerm(f *RbFdsetT) {
	var cF C.rb_fdset_t
	C.rb_fd_term(&cF)
	*f = RbFdsetT(cF)
}

// RbFdZero calls `rb_fd_zero` in C
//
// Original definition is following
//
//	void rb_fd_zero(rb_fdset_t *f)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/intern/select/largesize.h
func RbFdZero(f *RbFdsetT) {
	var cF C.rb_fdset_t
	C.rb_fd_zero(&cF)
	*f = RbFdsetT(cF)
}
