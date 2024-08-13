# frozen_string_literal: true

module Dummy
  class RbDefineClassUnderTest < Test::Unit::TestCase
    test "RbDefineClassUnder" do
      assert { Dummy::TestRbDefineClassUnder.is_a?(Class) }
    end
  end
end
