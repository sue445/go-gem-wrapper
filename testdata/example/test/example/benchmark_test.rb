# frozen_string_literal: true

module Example
  class BenchmarkTest < Test::Unit::TestCase
    test ".tarai" do
      assert { Example::Benchmark.tarai(2, 1, 0) == 2 }
    end
  end
end
