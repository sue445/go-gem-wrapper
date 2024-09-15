# frozen_string_literal: true
require "forwardable"

require_relative "ruby_header_parser"

require_relative "ruby_h_to_go/helper"
require_relative "ruby_h_to_go/argument_definition"
require_relative "ruby_h_to_go/function_definition"
require_relative "ruby_h_to_go/struct_definition"
require_relative "ruby_h_to_go/type_definition"
require_relative "ruby_h_to_go/typeref_definition"

# Generate Go binding from ruby.h
module RubyHToGo
end
