# frozen_string_literal: true

require "mkmf"

############ Appended for go native extension
find_executable("go")

# rubocop:disable Style/GlobalVars
$objs = []
def $objs.empty?; false; end
# rubocop:enable Style/GlobalVars

############ Appended for go native extension

# Makes all symbols private by default to avoid unintended conflict
# with other gems. To explicitly export symbols you can use RUBY_FUNC_EXPORTED
# selectively, or entirely remove this flag.
append_cflags("-fvisibility=hidden")

create_makefile("example/example")

############ Appended for go native extension
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
############ Appended for go native extension
