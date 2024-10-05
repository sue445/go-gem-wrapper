# frozen_string_literal: true

module RubyHToGo
  # type attribute helper
  module TypeHelper
    # @param pos [Symbol,nil] :arg, :typeref, :return
    # @param pointer [Symbol,nil] pointer hint (:ref, :array, :ref_array, :function, :sref, :str_array, :in_ref, :raw)
    # @param pointer_length [Integer]
    # @return [String]
    def ruby_c_type_to_go_type(pos: nil, pointer: nil, pointer_length: 0)
      GoUtil.ruby_c_type_to_go_type(type, pos:, pointer:, pointer_length:)
    end
  end
end
