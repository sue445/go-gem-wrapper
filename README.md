# [WIP] go-gem-wrapper
`go-gem-wrapper` is a wrapper for creating Ruby native extension in [Go](https://go.dev/)

> [!WARNING]
> This repository is currently under development.
> Don't use in production.

[![GitHub Tag](https://img.shields.io/github/v/tag/sue445/go-gem-wrapper)](https://github.com/sue445/go-gem-wrapper/releases)
[![build](https://github.com/sue445/go-gem-wrapper/actions/workflows/build.yml/badge.svg)](https://github.com/sue445/go-gem-wrapper/actions/workflows/build.yml)
[![Coverage Status](https://coveralls.io/repos/github/sue445/go-gem-wrapper/badge.svg)](https://coveralls.io/github/sue445/go-gem-wrapper)

## Requirements
* Go
* Ruby

## Getting started
At first, patch to make a gem into a Go gem right after `bundle gem`

See [_tools/patch_for_go_gem/](_tools/patch_for_go_gem/)

Please also add the following depending on the CI you are using.

### GitHub Actions
e.g.

```yml
- uses: actions/setup-go@v5
  with:
    go-version-file: ext/GEM_NAME/go.mod
```

## Implementing Ruby methods in Go
For example, consider the following Ruby method implemented in Go

```ruby
module Example
  def self.sum(a, b)
    a + b
  end
end
```

### 1. Implementing function in Go
```go
// ext/GEM_NAME/GEM_NAME.go

//export rb_example_sum
func rb_example_sum(_ C.VALUE, a C.VALUE, b C.VALUE) C.VALUE {
	aLong := ruby.NUM2LONG(ruby.VALUE(a))
	bLong := ruby.NUM2LONG(ruby.VALUE(b))

	sum := aLong + bLong

	return C.VALUE(ruby.LONG2NUM(sum))
}
```

### 2. Write C function definitions for Go functions
```go
// ext/GEM_NAME/GEM_NAME.go

/*
#include "example.h"

// TODO: Append this
VALUE rb_example_sum(VALUE self, VALUE a, VALUE b);
*/
import "C"
```

### 3. Call exported C functions with the Init function
```go
// ext/GEM_NAME/GEM_NAME.go

//export Init_example
func Init_example() {
	rb_mExample := ruby.RbDefineModule("Example")

	// TODO: Append this
	ruby.RbDefineSingletonMethod(rb_mExample, "sum", C.rb_example_sum, 2)
}
```

### More examples
See also

* [ruby/testdata/example/ext/example/example.go](ruby/testdata/example/ext/example/example.go)
* [ruby/testdata/example/ext/example/tests.go](ruby/testdata/example/ext/example/tests.go)

## Developing
### Build
Run `rake ruby:build_example`. (`bundle exec` is not required)

See `rake -T` for more tasks.

### See `godoc` in local
```bash
go install golang.org/x/tools/cmd/godoc@latest
godoc
```

open http://localhost:6060/pkg/github.com/sue445/go-gem-wrapper/

## Coverage
We provide auto-generated bindings for (almost) all CRuby functions available when including `ruby.h` :muscle:

See below for details.

* [ruby/enum_generated.go](ruby/enum_generated.go)
* [ruby/function_generated.go](ruby/function_generated.go)
* [ruby/type_generated.go](ruby/type_generated.go)
* [_tools/ruby_h_to_go/](_tools/ruby_h_to_go/)

## Original idea
[Ruby meets Go - RubyKaigi 2015](https://rubykaigi.org/2015/presentations/mmasaki/)
