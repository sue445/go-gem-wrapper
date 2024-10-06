# frozen_string_literal: true

module GoGem
  # Helper module for creating Go Makefiles
  module Mkmf
    # Create Makefile for go-gem
    #
    # @param target [String]
    # @param srcprefix [String,nil]
    #
    # @example
    #   require "mkmf"
    #   require "go_gem/mkmf" # Append this
    #
    #   # Use create_go_makefile instead of create_makefile
    #   # create_makefile("example/example")
    #   create_go_makefile("example/example")
    def create_go_makefile(target, srcprefix = nil)
      find_executable("go")

      # rubocop:disable Style/GlobalVars
      $objs = []
      # @private
      def $objs.empty?; false; end
      # rubocop:enable Style/GlobalVars

      create_makefile(target, srcprefix)

      case `#{CONFIG["CC"]} --version` # rubocop:disable Lint/LiteralAsCondition
      when /Free Software Foundation/
        ldflags = "-Wl,--unresolved-symbols=ignore-all"
      when /clang/
        ldflags = "-undefined dynamic_lookup"
      end

      current_dir = File.expand_path(".")

      File.open("Makefile", "a") do |f|
        f.write <<~MAKEFILE.gsub(/^ {8}/, "\t")
          $(DLLIB): Makefile $(srcdir)/*.go
                  cd $(srcdir); \
                  CGO_CFLAGS='$(INCFLAGS)' CGO_LDFLAGS='#{ldflags}' \
                    go build -p 4 -buildmode=c-shared -o #{current_dir}/$(DLLIB)
        MAKEFILE
      end
    end
  end
end

include GoGem::Mkmf # rubocop:disable Style/MixinUsage
