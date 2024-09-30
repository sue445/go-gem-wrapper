package main

/*
#include "example.h"

VALUE rb_example_benchmark_tarai(VALUE self, VALUE x, VALUE y, VALUE z);
VALUE rb_example_benchmark_tarai_goroutine(VALUE self, VALUE x, VALUE y, VALUE z, VALUE times);
*/
import "C"

import (
	"github.com/sue445/go-gem-wrapper/ruby"
	"sync"
)

//export rb_example_benchmark_tarai
func rb_example_benchmark_tarai(_ C.VALUE, x C.VALUE, y C.VALUE, z C.VALUE) C.VALUE {
	ret := tarai(
		ruby.NUM2INT(ruby.VALUE(x)),
		ruby.NUM2INT(ruby.VALUE(y)),
		ruby.NUM2INT(ruby.VALUE(z)),
	)

	return C.VALUE(ruby.INT2NUM(ret))
}

func tarai(x int, y int, z int) int {
	if x <= y {
		return y
	}

	return tarai(tarai(x-1, y, z), tarai(y-1, z, x), tarai(z-1, x, y))
}

//export rb_example_benchmark_tarai_goroutine
func rb_example_benchmark_tarai_goroutine(_ C.VALUE, x C.VALUE, y C.VALUE, z C.VALUE, times C.VALUE) C.VALUE {
	ret := tarai_goroutine(
		ruby.NUM2INT(ruby.VALUE(x)),
		ruby.NUM2INT(ruby.VALUE(y)),
		ruby.NUM2INT(ruby.VALUE(z)),
		ruby.NUM2INT(ruby.VALUE(times)),
	)

	var values []ruby.VALUE
	for _, i := range ret {
		values = append(values, ruby.VALUE(i))
	}

	return C.VALUE(ruby.Slice2rbAry(values))
}

func tarai_goroutine(x int, y int, z int, times int) []int {
	var wg sync.WaitGroup
	var mu sync.Mutex

	var values []int
	for i := 0; i < times; i++ {
		wg.Add(1)
		go func() {
			ret := tarai(x, y, z)

			mu.Lock()
			values = append(values, ret)
			mu.Unlock()

			wg.Done()
		}()
	}

	wg.Wait()
	return values
}

// defineMethodsToExampleBenchmark define methods in Example::Benchmark
func defineMethodsToExampleBenchmark(rb_mExample ruby.VALUE) {
	// Create Example::GoStruct class
	rb_mBenchmark := ruby.RbDefineModuleUnder(rb_mExample, "Benchmark")

	ruby.RbDefineSingletonMethod(rb_mBenchmark, "tarai", C.rb_example_benchmark_tarai, 3)
	ruby.RbDefineSingletonMethod(rb_mBenchmark, "tarai_goroutine", C.rb_example_benchmark_tarai_goroutine, 4)
}
