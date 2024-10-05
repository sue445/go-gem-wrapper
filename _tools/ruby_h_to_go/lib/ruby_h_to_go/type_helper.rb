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

    # Cast C type to cgo type. (Used in wrapper function)
    # @return [String]
    def cast_to_cgo_type
      GoUtil.cast_to_cgo_type(type)
    end
  end
end
