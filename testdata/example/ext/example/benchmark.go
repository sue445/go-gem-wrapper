package main

/*
#include "example.h"

VALUE rb_example_benchmark_tarai(VALUE self, VALUE x, VALUE y, VALUE z);
*/
import "C"

import (
	ruby "github.com/sue445/go-gem-wrapper"
)

//export rb_example_benchmark_tarai
func rb_example_benchmark_tarai(_ C.VALUE, x C.VALUE, y C.VALUE, z C.VALUE) C.VALUE {
	ret := tarai(
		int(ruby.NUM2INT(ruby.VALUE(x))),
		int(ruby.NUM2INT(ruby.VALUE(y))),
		int(ruby.NUM2INT(ruby.VALUE(z))),
	)

	return C.VALUE(ruby.INT2NUM(ruby.Int(ret)))
}

func tarai(x int, y int, z int) int {
	if x <= y {
		return y
	}

	return tarai(tarai(x-1, y, z), tarai(y-1, z, x), tarai(z-1, x, y))
}

// defineMethodsToExampleBenchmark define methods in Example::Benchmark
func defineMethodsToExampleBenchmark(rb_mExample ruby.VALUE) {
	// Create Example::GoStruct class
	rb_mBenchmark := ruby.RbDefineModuleUnder(rb_mExample, "Benchmark")

	ruby.RbDefineSingletonMethod(rb_mBenchmark, "tarai", C.rb_example_benchmark_tarai, 3)
}
