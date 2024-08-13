# frozen_string_literal: true

module Dummy
  class RbDefineModuleUnderTest < Test::Unit::TestCase
    test "RbDefineModuleUnder" do
      assert { Dummy::TestRbDefineModuleUnder.is_a?(Module) }
    end
  end
end
