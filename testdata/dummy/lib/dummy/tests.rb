# frozen_string_literal: true

module Dummy
  # Class for implementing methods that calls a wrapper function that calls Ruby C methods
  class Tests
    attr_accessor :ivar

    # @param ivar [Object]
    def initialize(ivar = nil)
      @ivar = ivar
    end
  end
end
