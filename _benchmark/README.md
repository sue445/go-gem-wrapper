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
          sequential      0.017 (± 0.0%) i/s    (57.45 s/i) -      1.000 in  57.451544s
   parallel (Ractor)      0.052 (± 0.0%) i/s    (19.28 s/i) -      1.000 in  19.281159s
parallel (goroutine)      1.384 (± 0.0%) i/s  (722.59 ms/i) -      7.000 in   5.062048s

Comparison:
parallel (goroutine):        1.4 i/s
   parallel (Ractor):        0.1 i/s - 26.68x  slower
          sequential:        0.0 i/s - 79.51x  slower
```
