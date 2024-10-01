# frozen_string_literal: true

module TestHelper # rubocop:disable Style/Documentation
  def argument(type:, name:, pointer: nil, length: 0)
    RubyHeaderParser::ArgumentDefinition.new(type:, name:, pointer:, length:)
  end

  def typeref(type:, pointer: nil)
    RubyHeaderParser::TyperefDefinition.new(type:, pointer:)
  end
end
