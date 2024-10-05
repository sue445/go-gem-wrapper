# frozen_string_literal: true

require "yaml"

# Parser for ruby.h
module RubyHeaderParser
  autoload :ArgumentDefinition, "ruby_header_parser/argument_definition"
  autoload :Data,               "ruby_header_parser/data"
  autoload :EnumDefinition,     "ruby_header_parser/enum_definition"
  autoload :FunctionDefinition, "ruby_header_parser/function_definition"
  autoload :Parser,             "ruby_header_parser/parser"
  autoload :StructDefinition,   "ruby_header_parser/struct_definition"
  autoload :TypeDefinition,     "ruby_header_parser/type_definition"
  autoload :TyperefDefinition,  "ruby_header_parser/typeref_definition"
  autoload :Util,               "ruby_header_parser/util"
end
