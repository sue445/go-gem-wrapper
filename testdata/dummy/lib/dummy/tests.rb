# frozen_string_literal: true

module Dummy
  class Tests # rubocop:disable Style/Documentation
    attr_accessor :source

    # @param source [Integer]
    def initialize(source)
      @source = source
    end
  end
end
