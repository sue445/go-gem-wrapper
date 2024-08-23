require "benchmark/ips"

require_relative "../testdata/example/lib/example"

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

  x.compare!
end
