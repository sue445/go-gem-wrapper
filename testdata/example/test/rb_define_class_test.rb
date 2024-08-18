# frozen_string_literal: true

class RbDefineClassTest < Test::Unit::TestCase
  test "RbDefineClass" do
    assert { TestRbDefineClass.is_a?(Class) }
  end
end
