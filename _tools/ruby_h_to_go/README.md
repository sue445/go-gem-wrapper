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
Output binding to [/ruby/](/ruby/) using Ruby available in current context **(recommended)**

```bash
bundle exec rake ruby_h_to_go
```

Customize Ruby version to be used, output directory.

```bash
./exe/ruby_h_to_go
```

* `-H`, `--header-file` : ruby header file. (default: `"#{RbConfig::CONFIG["rubyhdrdir"]}/ruby.h"`)
* `-I`, `--include-path` : include paths (default: `[RbConfig::CONFIG["rubyarchhdrdir"], RbConfig::CONFIG["rubyhdrdir"]]`)
* `--dist-dir` : dist dir for auto-generated Go code (default: [../../ruby/](../../ruby/))
* `-t`, `--temp-file` : temporary dist preprocessed ruby header file (default: `"#{Dir.tmpdir}/ruby_preprocessed.h"`)
