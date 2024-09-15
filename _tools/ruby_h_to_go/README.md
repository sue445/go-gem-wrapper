# ruby_h_to_go
Convert Ruby C function definition in `ruby.h` to Go source and dump to `dist/`.

## Requirements
* Ruby
* Go
* ctags
  * macOS: `brew install universal-ctags`
  * Ubuntu: `apt-get install -y universal-ctags`

## Usage
```bash
./exe/ruby_h_to_go -H path/to/ruby/header/dir
```

* `-H` : path to ruby header dir. (default: `RbConfig::CONFIG["rubyhdrdir"]`)

In many cases there is an error on the last `go fmt`, but it's not a problem :sweat_smile:
