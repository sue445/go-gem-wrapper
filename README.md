# go-gem-wrapper
`go-gem-wrapper` is a wrapper for creating Ruby native extension in [Go](https://go.dev/)

[![build](https://github.com/sue445/go-gem-wrapper/actions/workflows/build.yml/badge.svg)](https://github.com/sue445/go-gem-wrapper/actions/workflows/build.yml)

## Requirements
* Go
* Ruby

## Developing
### Build
Run `rake ruby:build_dummy`. (`bundle exec` is not required)

See `rake -T` for more tasks.

### Add wrapper function for C
Run `ruby _scripts/dump_ruby_c_functions.rb`

Executing [`ruby ./_scripts/dump_ruby_c_functions.rb`](./_scripts/dump_ruby_c_functions.rb) will generate Go source code under `_scripts/dist/` based on `ruby.h`

In many cases there is an error on the last `go fmt`, but it's not a problem :sweat_smile:

Modify some of the auto-generated functions and add them to the ruby package in the top directory

### See `godoc` in local
```bash
go install golang.org/x/tools/cmd/godoc@latest
godoc
```

open http://localhost:6060/pkg/github.com/sue445/go-gem-wrapper/
