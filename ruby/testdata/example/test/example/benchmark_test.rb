# frozen_string_literal: true

module Example
  class BenchmarkTest < Test::Unit::TestCase
    test ".tarai" do
      assert { Example::Benchmark.tarai(2, 1, 0) == 2 }
    end

    test ".tarai_goroutine" do
      assert { Example::Benchmark.tarai_goroutine(2, 1, 0, 2) == [2, 2] }
    end
  end
end
