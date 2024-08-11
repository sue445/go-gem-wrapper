# frozen_string_literal: true

module TestHelpers
  # @yield
  def silence_warning
    original_verbose = $VERBOSE
    $VERBOSE = nil

    yield
  ensure
    $VERBOSE = original_verbose
  end
end
