#include "dummy.h"

VALUE rb_mDummy;

RUBY_FUNC_EXPORTED void
Init_dummy(void)
{
  rb_mDummy = rb_define_module("Dummy");
}
