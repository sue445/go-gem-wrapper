# frozen_string_literal: true

module RubyHToGo
  # client for ruby_h_to_go
  class Cli
    # @!attribute [r] header_dir
    #   @return [String]
    attr_reader :header_dir

    # @!attribute [r] dist_dir
    #   @return [String]
    attr_reader :dist_dir

    # @param header_dir [String]
    # @param dist_dir [String]
    def initialize(header_dir:, dist_dir:)
      @header_dir = header_dir
      @dist_dir = dist_dir
    end

    def perform
      clean_generated_files

      write_type_definitions_to_go_file
      write_struct_definitions_to_go_file
      write_function_definitions_to_go_file

      copy_go_files
      remove_unused_imports
      go_fmt
    end

    private

    # @return [RubyHeaderParser::Parser]
    def parser
      @parser ||= RubyHeaderParser::Parser.new(header_dir)
    end

    def write_type_definitions_to_go_file
      type_definitions = parser.extract_type_definitions.map do |definition|
        RubyHToGo::TypeDefinition.new(definition:, header_dir:)
      end

      type_definitions.each do |definition|
        definition.write_go_file(dist_dir)
      end
    end

    def write_struct_definitions_to_go_file
      struct_definitions = parser.extract_struct_definitions.map do |definition|
        RubyHToGo::StructDefinition.new(definition:, header_dir:)
      end

      struct_definitions.each do |definition|
        definition.write_go_file(dist_dir)
      end
    end

    def write_function_definitions_to_go_file
      function_definitions = parser.extract_function_definitions.map do |definition|
        RubyHToGo::FunctionDefinition.new(definition:, header_dir:)
      end

      static_inline_function_definitions = parser.extract_static_inline_function_definitions.map do |definition|
        RubyHToGo::FunctionDefinition.new(definition:, header_dir:)
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
