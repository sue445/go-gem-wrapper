# frozen_string_literal: true

module RubyHeaderParser
  # util methods
  module Util
    # @param array [Array<String>]
    # @param field_name [String]
    # @return [String,nil]
    def self.find_field(array, field_name)
      array.each do |element|
        return element.delete_prefix("#{field_name}:") if element.start_with?("#{field_name}:")
      end

      nil
    end

    # @param signature [String]
    # @return [Array<String>]
    def self.split_signature(signature)
      signature.scan(/[^,]+\([^()]*\)|[^,]+/).map(&:strip)
    end

    # @param type [String]
    # @return [String]
    def self.sanitize_type(type)
      type.gsub(/(RUBY_EXTERN|enum|volatile|const|struct)\s+/i, "").strip
    end
  end
end
