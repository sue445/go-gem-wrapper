# Benchmark
## tarai
```bash
$ ruby tarai.rb
ruby 3.3.5 (2024-09-03 revision ef084cc8f4) [arm64-darwin23]
Warming up --------------------------------------
          sequential     1.000 i/100ms
   parallel (Ractor)     1.000 i/100ms
parallel (goroutine)     1.000 i/100ms
Calculating -------------------------------------
          sequential      0.017 (± 0.0%) i/s    (57.66 s/i) -      1.000 in  57.660028s
   parallel (Ractor)      0.050 (± 0.0%) i/s    (20.04 s/i) -      1.000 in  20.038214s
parallel (goroutine)      1.327 (± 0.0%) i/s  (753.61 ms/i) -      7.000 in   5.275383s

Comparison:
parallel (goroutine):        1.3 i/s
   parallel (Ractor):        0.0 i/s - 26.59x  slower
          sequential:        0.0 i/s - 76.51x  slower
```
