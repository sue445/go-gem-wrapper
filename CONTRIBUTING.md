# Contribution Guide
## Add wrapper function for C
### 1. Generate skeleton
Run `ruby _scripts/dump_ruby_c_functions.rb`

Executing [`ruby _scripts/dump_ruby_c_functions.rb`](./_scripts/dump_ruby_c_functions.rb) will generate Go source code under `_scripts/dist/` based on `ruby.h`

In many cases there is an error on the last `go fmt`, but it's not a problem :sweat_smile:

### 2. Move function to top directory
Modify some of the auto-generated functions and add them to the ruby package in the top directory

### 3. Add a test that calls the added function
There is a dummy gem for this wrapper in [testdata/dummy/](testdata/dummy/).

Refer to following and add test code to call the added wrapper function.

* [testdata/dummy/ext/dummy/dummy.go](testdata/dummy/ext/dummy/dummy.go)
* [testdata/dummy/sig/dummy.rbs](testdata/dummy/sig/dummy.rbs)
* [testdata/dummy/spec/dummy_spec.rb](testdata/dummy/spec/dummy_spec.rb)

### 4. Run test
Run `rake ruby:build_dummy`.

### 5. Check coverage
[Coverage](README.md#coverage) lists Ruby's C functions, so check the functions you have added. (if there is no entry, add it)

### 6. Send patch
