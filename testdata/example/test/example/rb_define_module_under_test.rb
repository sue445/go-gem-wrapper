# frozen_string_literal: true

module Example
  class RbDefineModuleUnderTest < Test::Unit::TestCase
    test "RbDefineModuleUnder" do
      assert { Example::TestRbDefineModuleUnder.is_a?(Module) }
    end
  end
end
