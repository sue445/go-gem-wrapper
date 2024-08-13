# frozen_string_literal: true

class DummyTest < Test::Unit::TestCase
  test ".sum" do
    assert { Dummy.sum(1, 2) == 3 }
  end

  test ".hello" do
    assert { Dummy.hello("sue445") == "Hello, sue445" }
  end

  test ".to_string" do
    assert { Dummy.to_string(123) == "123" }
  end

  test ".max" do
    assert { Dummy.max(3, 2) == 3 }
    assert { Dummy.max(1, 2) == 2 }
  end

  class IncludeDummyTest < Test::Unit::TestCase
    include Dummy

    test "#max" do
      assert { max(3, 2) == 3 }
      assert { max(1, 2) == 2 }
    end
  end
end
