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

    # Convert C type to Go type. (used in wrapper function args and return type etc)
    # @param typename [String]
    # @param type [Symbol,nil] :arg, :return
    # @param pointer [Symbol,nil] Whether pointer hint
    # @return [String]
    def ruby_c_type_to_go_type(typename, type: nil, pointer: nil)
      typename = typename.delete_prefix("struct ").delete_prefix("volatile ")

      if pointer
        case typename
        when "char", "const char"
          case type
          when :arg, :return
            return "string"
          else
            return "char2String"
          end
        when "void"
          return "unsafe.Pointer"
        end

        go_type_name = ruby_c_type_to_go_type(typename, type: type, pointer: nil)

        return "[]#{go_type_name}" if pointer == :array

        return "*#{go_type_name}"
      end

      case typename
      when "unsigned int", "unsigned long"
        return "uint"
      when "unsigned char"
        return "Uchar"
      when /^VALUE\s*\(\*func\)\s*\(ANYARGS\)$/
        return "unsafe.Pointer"
      when /^[A-Z]+$/, "int"
        # e.g. VALUE
        return typename
      when "void"
        return "unsafe.Pointer" if pointer == :ref && type == :return
      end

      snake_to_camel(typename)
    end
  end
end
