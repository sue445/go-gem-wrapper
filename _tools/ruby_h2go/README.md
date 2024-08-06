# ruby_h2go
Convert Ruby C function definition in `ruby.h` to Go source and dump to `dist/`.

## Requirements
* Ruby
* Go
* ctags
  * NOTE: `universal-ctags` is required when macOS
  * c.f. https://formulae.brew.sh/formula/universal-ctags

## Usage
```bash
ruby ruby_h2go.rb -H path/to/ruby/header/dir
```

* `-H` : path to ruby header dir. (default: `RbConfig::CONFIG["rubyhdrdir"]`)

In many cases there is an error on the last `go fmt`, but it's not a problem :sweat_smile:
