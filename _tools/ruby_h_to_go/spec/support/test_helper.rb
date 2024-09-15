module TestHelper
  def argument(type:, name:, pointer: nil)
    RubyHeaderParser::ArgumentDefinition.new(type:, name:, pointer:)
  end

  def typedef(type:, pointer: nil)
    RubyHeaderParser::TyperefDefinition.new(type:, pointer:)
  end
end