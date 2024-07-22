package main

import "C"

import (
	"github.com/sue445/go-gem-wrapper"
)

var rb_mDummy ruby.VALUE

//export Init_dummy
func Init_dummy() {
	rb_mDummy = ruby.RbDefineModule("Dummy")
}

func main() {
}
