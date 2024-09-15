module RubyHToGo
  module Helper
    # @param header_dir [String]
    # @param ruby_header_file [String]
    # @return [String]
    def go_file_name(header_dir:, ruby_header_file:)
      ruby_header_file.delete_prefix(header_dir + File::SEPARATOR).gsub(File::SEPARATOR, "-").gsub(/\.h$/, ".go")
    end

    # @param str [String]
    # @return [String]
    def snake_to_camel(str)
      return str if %w(VALUE ID).include?(str)
      str.split("_").map(&:capitalize).join.gsub(/(?<=\d)([a-z])/) { _1.upcase }
    end

    # Generate initial go file whether not exists
    # @param go_file_path [String]
    def generate_initial_go_file(go_file_path)
      return if File.exist?(go_file_path)

      File.open(go_file_path, "wb") do |f|
        f.write(<<~GO)
          package ruby
  
          /*
          #include "ruby.h"
          */
          import "C"

        GO
      end
    end
  end
end
