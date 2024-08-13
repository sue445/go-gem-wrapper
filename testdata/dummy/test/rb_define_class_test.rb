# frozen_string_literal: true

class RbDefineClassUnderTest < Test::Unit::TestCase
  test "RbDefineClass" do
    assert { TestRbDefineClass.is_a?(Class) }
  end
end
