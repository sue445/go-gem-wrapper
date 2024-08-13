# Contribution Guide
## Add wrapper function for C
### :warning: Limitation
Go variable-length arguments cannot be passed directly to C functions

e.g. `void rb_raise(VALUE exc, const char *fmt, ...)`

To avoid this problem, we need to call the C function without variable-length arguments

See `RbRaise` implementation in [ruby-internal-error.go](ruby-internal-error.go) for details

### 1. Generate skeleton
Run `ruby _tools/ruby_h_to_go/ruby_h_to_go.rb`

See [_tools/ruby_h_to_go/](_tools/ruby_h_to_go/)

### 2. Move function to top directory
Modify some of the auto-generated functions and add them to the ruby package in the top directory

### 3. Add a test that calls the added function
There is a dummy gem for this wrapper in [testdata/dummy/](testdata/dummy/).

Refer to following and add test code to call the added wrapper function.

* [testdata/dummy/ext/dummy/tests.go](testdata/dummy/ext/dummy/tests.go)
* [testdata/dummy/sig/dummy/tests.rbs](testdata/dummy/sig/dummy/tests.rbs)
* [testdata/dummy/test/dummy/tests_test.rb](testdata/dummy/test/dummy/tests_test.rb)

### 4. Run test
Run `rake ruby:build_dummy`.

### 5. Check coverage
[Coverage](README.md#coverage) lists Ruby's C functions, so check the functions you have added. (if there is no entry, add it)

### 6. Send patch
