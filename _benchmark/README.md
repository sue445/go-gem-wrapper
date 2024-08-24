# Benchmark
## Setup

At first, run `rake ruby:build_example` at repository root.

## tarai
```bash
$ ruby tarai.rb
ruby 3.3.4 (2024-07-09 revision be1089c8ec) [arm64-darwin23]
Warming up --------------------------------------
          sequential     1.000 i/100ms
   parallel (Ractor)     1.000 i/100ms
parallel (goroutine)     1.000 i/100ms
Calculating -------------------------------------
          sequential      0.018 (± 0.0%) i/s -      1.000 in  56.805109s
   parallel (Ractor)      0.050 (± 0.0%) i/s -      1.000 in  19.821107s
parallel (goroutine)      1.354 (± 0.0%) i/s -      7.000 in   5.171658s

Comparison:
parallel (goroutine):        1.4 i/s
   parallel (Ractor):        0.1 i/s - 26.83x  slower
          sequential:        0.0 i/s - 76.90x  slower
```
