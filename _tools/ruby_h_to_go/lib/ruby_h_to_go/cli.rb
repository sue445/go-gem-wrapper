# frozen_string_literal: true

module RubyHToGo
  # client for ruby_h_to_go
  class Cli
    # @!attribute [r] header_file
    #   @return [String]
    attr_reader :header_file

    # @!attribute [r] include_paths
    #   @return [Array<String>]
    attr_reader :include_paths

    # @!attribute [r] dist_dir
    #   @return [String]
    attr_reader :dist_dir

    # @!attribute [r] dist_preprocessed_header_file
    #   @return [String]
    attr_reader :dist_preprocessed_header_file

    # @param header_file [String] path to ruby.h
    # @param include_paths [Array<String>]
    # @param dist_dir [String]
    # @param dist_preprocessed_header_file [String]
    def initialize(header_file:, include_paths:, dist_dir:, dist_preprocessed_header_file:)
      @header_file = header_file
      @include_paths = include_paths
      @dist_dir = dist_dir
      @dist_preprocessed_header_file = dist_preprocessed_header_file
    end

    def perform
      clean_generated_files

      write_type_definitions_to_go_file
      write_struct_definitions_to_go_file
      write_function_definitions_to_go_file

      copy_go_files

      # FIXME: Enable after
      # remove_unused_imports
      # go_fmt
    end

    private

    # @return [RubyHeaderParser::Parser]
    def parser
      @parser ||= RubyHeaderParser::Parser.new(header_file:, include_paths:, dist_preprocessed_header_file:)
    end

    def write_type_definitions_to_go_file
      type_definitions = parser.extract_type_definitions.map do |definition|
        RubyHToGo::TypeDefinition.new(definition:)
      end

      type_definitions.each do |definition|
        definition.write_go_file(dist_dir)
      end
    end

    def write_struct_definitions_to_go_file
      struct_definitions = parser.extract_struct_definitions.map do |definition|
        RubyHToGo::StructDefinition.new(definition:)
      end

      struct_definitions.each do |definition|
        definition.write_go_file(dist_dir)
      end
    end

    def write_function_definitions_to_go_file
      function_definitions = parser.extract_function_definitions.map do |definition|
        RubyHToGo::FunctionDefinition.new(definition:)
      end

      static_inline_function_definitions = parser.extract_static_inline_function_definitions.map do |definition|
        RubyHToGo::FunctionDefinition.new(definition:)
      end

      static_inline_function_definitions.each do |static_inline_function_definition|
        unless function_definitions.map(&:name).include?(static_inline_function_definition.name)
          function_definitions << static_inline_function_definition
        end
      end

      function_definitions.each do |definition|
        definition.write_go_file(dist_dir)
      end
    end

    # Clean all generated files in dist/
    def clean_generated_files
      FileUtils.rm_f(Dir.glob(File.join(dist_dir, "*.go")))
    end

    def copy_go_files
      src_dir = File.expand_path("../../../../ruby", __dir__)
      return if src_dir == dist_dir

      %w[
        c_types.go
        types.go
        wrapper.go
      ].each do |file|
        FileUtils.cp(File.join(src_dir, file), dist_dir)
      end
    end

    def remove_unused_imports
      ret = system("which goimports")
      raise "goimports isn't installed. Run `go install golang.org/x/tools/cmd/goimports@latest`" unless ret

      Dir.chdir(dist_dir) do
        system("goimports -w *.go", exception: true)
      end
    end

    def go_fmt
      Dir.chdir(dist_dir) do
        system("go fmt", exception: true)
      end
    end
  end
end
