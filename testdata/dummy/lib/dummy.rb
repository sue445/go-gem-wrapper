# frozen_string_literal: true

require_relative "dummy/version"
require_relative "dummy/dummy"
require_relative "dummy/tests"
require_relative "dummy/go_struct"

module Dummy
  class Error < StandardError; end
  # Your code goes here...
end
