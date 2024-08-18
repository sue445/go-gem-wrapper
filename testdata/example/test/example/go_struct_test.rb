# frozen_string_literal: true

module Example
  class GoStructTest < Test::Unit::TestCase
    test "#set and #get" do
      data = Example::GoStruct.new
      data.set(1, 2)

      x, y = data.get
      assert { x == 1 }
      assert { y == 2 }
    end
  end
end
