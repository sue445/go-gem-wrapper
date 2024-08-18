# frozen_string_literal: true

class ExampleTest < Test::Unit::TestCase
  test ".sum" do
    assert { Example.sum(1, 2) == 3 }
  end

  test ".hello" do
    assert { Example.hello("sue445") == "Hello, sue445" }
  end

  test ".to_string" do
    assert { Example.to_string(123) == "123" }
  end

  test ".max" do
    assert { Example.max(3, 2) == 3 }
    assert { Example.max(1, 2) == 2 }
  end

  class IncludeExampleTest < Test::Unit::TestCase
    include Example

    test "#max" do
      assert { max(3, 2) == 3 }
      assert { max(1, 2) == 2 }
    end
  end
end
