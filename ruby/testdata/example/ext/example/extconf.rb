# frozen_string_literal: true

require "mkmf"

############ Appended for go native extension
require "go_gem/mkmf"
############ Appended for go native extension

# Makes all symbols private by default to avoid unintended conflict
# with other gems. To explicitly export symbols you can use RUBY_FUNC_EXPORTED
# selectively, or entirely remove this flag.
append_cflags("-fvisibility=hidden")

############ Appended for go native extension
create_go_makefile("example/example")
############ Appended for go native extension
