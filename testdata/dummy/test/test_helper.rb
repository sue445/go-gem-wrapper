# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "dummy"

require "test-unit"

Dir["#{__dir__}/support/**/*.rb"].each { |f| require f }
