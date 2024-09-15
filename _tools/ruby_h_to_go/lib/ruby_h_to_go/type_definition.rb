# frozen_string_literal: true

module RubyHToGo
  # Proxy class for generating go type
  class TypeDefinition
    extend Forwardable

    def_delegators :@definition, :==, :name, :name=, :filepath, :filepath=

    include Helper

    # @param definition [RubyHeaderParser::TypeDefinition]
    def initialize(definition)
      @definition = definition
    end

    # Write definition as go file
    # @param [String] dist_dir
    # @param [String] header_dir
    def write_go_file(dist_dir:, header_dir:)
      go_file_path = File.join(dist_dir, go_file_name(header_dir:, ruby_header_file: filepath))

      generate_initial_go_file(go_file_path)

      File.open(go_file_path, "a") do |f|
        f.write(generate_go_content)
      end
    end

    # @return [String]
    def generate_go_content
      go_type_name = snake_to_camel(name)

      <<~GO
        // #{go_type_name} is a type for passing `C.#{name}` in and out of package
        type #{go_type_name} C.#{name}

      GO
    end
  end
end
