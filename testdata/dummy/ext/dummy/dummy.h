#ifndef DUMMY_H
#define DUMMY_H 1

#include "ruby.h"

VALUE rb_dummy_sum(VALUE self, VALUE a, VALUE b);
VALUE rb_dummy_with_block(VALUE self, VALUE arg);
VALUE rb_dummy_with_block2(VALUE self, VALUE arg);
VALUE rb_dummy_hello(VALUE self, VALUE name);
VALUE rb_dummy_round_num2(VALUE self, VALUE num, VALUE ndigits);
VALUE rb_dummy_round_num3(VALUE self, VALUE num, VALUE ndigits);
VALUE rb_dummy_to_string(VALUE self, VALUE source);
VALUE rb_dummy_max(VALUE self, VALUE a, VALUE b);

VALUE rb_dummy_tests_kilobyte(VALUE self);
VALUE rb_dummy_tests_increment(VALUE self);

#endif /* DUMMY_H */
