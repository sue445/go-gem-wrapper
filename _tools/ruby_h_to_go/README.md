# ruby_h_to_go
Convert Ruby C function definition in `ruby.h` to Go source and dump to `dist/`.

## Requirements
* Ruby
* Go
* ctags
  * macOS: `brew install universal-ctags`
  * Ubuntu: `apt-get install -y universal-ctags`
* [goimports](https://pkg.go.dev/golang.org/x/tools/cmd/goimports)
  * `go install golang.org/x/tools/cmd/goimports@latest`

## Usage
```bash
./exe/ruby_h_to_go -H path/to/ruby/header/dir
```

* `-H` : path to ruby header dir. (default: `RbConfig::CONFIG["rubyhdrdir"]`)
