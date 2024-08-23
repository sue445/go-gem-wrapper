require "benchmark/ips"

require_relative "../testdata/example/lib/example"

# c.f. https://www.ruby-lang.org/en/news/2020/12/25/ruby-3-0-0-released/
def tarai(x, y, z) =
  x <= y ? y : tarai(tarai(x-1, y, z),
                     tarai(y-1, z, x),
                     tarai(z-1, x, y))

# Suppress Ractor warning
$VERBOSE = nil

Benchmark.ips do |x|
  # sequential version
  x.report("sequential"){ 4.times{ tarai(14, 7, 0) } }

  # parallel version
  x.report("parallel (Ractor)"){
    4.times.map do
      Ractor.new { tarai(14, 7, 0) }
    end.each(&:take)
  }

  # goroutine version
  x.report("parallel (goroutine)"){ Example::Benchmark.tarai_goroutine(14, 7, 0, 4) }

  x.compare!
end
