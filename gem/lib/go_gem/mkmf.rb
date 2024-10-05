# frozen_string_literal: true

require "mkmf"

module GoGem
  # Helper module for creating Go Makefiles
  module Mkmf
    # @param target [String]
    # @param srcprefix [String,nil]
    def create_go_makefile(target, srcprefix = nil)
      create_makefile(target, srcprefix)
    end
  end
end

include GoGem::Mkmf # rubocop:disable Style/MixinUsage
