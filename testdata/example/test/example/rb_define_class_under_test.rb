# frozen_string_literal: true

module Example
  class RbDefineClassUnderTest < Test::Unit::TestCase
    test "RbDefineClassUnder" do
      assert { Example::TestRbDefineClassUnder.is_a?(Class) }
    end
  end
end
