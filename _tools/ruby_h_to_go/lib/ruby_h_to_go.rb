# frozen_string_literal: true

require "forwardable"

require_relative "ruby_header_parser"

# Generate Go binding from ruby.h
module RubyHToGo
  autoload :ArgumentDefinition, "ruby_h_to_go/argument_definition"
  autoload :Cli,                "ruby_h_to_go/cli"
  autoload :GoUtil,             "ruby_h_to_go/go_util"
  autoload :EnumDefinition,     "ruby_h_to_go/enum_definition"
  autoload :FunctionDefinition, "ruby_h_to_go/function_definition"
  autoload :StructDefinition,   "ruby_h_to_go/struct_definition"
  autoload :TypeDefinition,     "ruby_h_to_go/type_definition"
  autoload :TypeHelper,         "ruby_h_to_go/type_helper"
  autoload :TyperefDefinition,  "ruby_h_to_go/typeref_definition"
end
