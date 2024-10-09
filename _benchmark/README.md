# Benchmark
## Ruby's [Ractor](https://docs.ruby-lang.org/en/master/ractor_md.html) vs Go's [goroutine](https://go.dev/tour/concurrency/1)
Benchmark with [tak function](https://en.wikipedia.org/wiki/Tak_(function)) [^tak]

[^tak]: https://www.ruby-lang.org/en/news/2020/12/25/ruby-3-0-0-released/

```bash
$ ruby tarai.rb
go version go1.23.2 darwin/arm64
ruby 3.3.5 (2024-09-03 revision ef084cc8f4) [arm64-darwin23]
Warming up --------------------------------------
          sequential     1.000 i/100ms
   parallel (Ractor)     1.000 i/100ms
parallel (goroutine)     1.000 i/100ms
Calculating -------------------------------------
          sequential      0.019 (± 0.0%) i/s    (51.42 s/i) -      1.000 in  51.417686s
   parallel (Ractor)      0.059 (± 0.0%) i/s    (17.02 s/i) -      1.000 in  17.022087s
parallel (goroutine)      1.677 (± 0.0%) i/s  (596.20 ms/i) -      9.000 in   5.365863s

Comparison:
parallel (goroutine):        1.7 i/s
   parallel (Ractor):        0.1 i/s - 28.55x  slower
          sequential:        0.0 i/s - 86.24x  slower```
```
