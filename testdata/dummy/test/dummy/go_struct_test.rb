# frozen_string_literal: true

module Dummy
  class GoStructTest < Test::Unit::TestCase
    test "#set and #get" do
      data = Dummy::GoStruct.new
      data.set(1, 2)

      x, y = data.get
      assert { x == 1 }
      assert { y == 2 }
    end
  end
end
