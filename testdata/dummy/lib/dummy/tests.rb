# frozen_string_literal: true

module Dummy
  # Class for implementing methods that calls a wrapper function that calls Ruby C methods
  class Tests
    attr_accessor :source

    # @param source [Object]
    def initialize(source = nil)
      @source = source
    end
  end
end
