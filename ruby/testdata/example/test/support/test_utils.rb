# frozen_string_literal: true

module TestUtils # rubocop:disable Style/Documentation
  # @yield
  def silence_warning
    original_verbose = $VERBOSE
    $VERBOSE = nil

    yield
  ensure
    $VERBOSE = original_verbose
  end
end
