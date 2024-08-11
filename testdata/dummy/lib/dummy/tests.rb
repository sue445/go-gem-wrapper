# frozen_string_literal: true

module Dummy
  # Class for implementing methods that calls a wrapper function that calls Ruby C methods
  class Tests
    CONST = "TEST"

    attr_accessor :ivar

    # @param ivar [Object]
    def initialize(ivar = nil)
      @ivar = ivar
      @ivar2 = nil
    end
  end
end
