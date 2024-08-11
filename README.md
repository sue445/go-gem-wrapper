# [WIP] go-gem-wrapper
`go-gem-wrapper` is a wrapper for creating Ruby native extension in [Go](https://go.dev/)

> [!WARNING]
> This repository is currently under development.
> Don't use in production.

[![build](https://github.com/sue445/go-gem-wrapper/actions/workflows/build.yml/badge.svg)](https://github.com/sue445/go-gem-wrapper/actions/workflows/build.yml)

## Requirements
* Go
* Ruby

## Getting started
At first, patch to make a gem into a Go gem right after `bundle gem`

See [_tools/patch_for_go_gem/](_tools/patch_for_go_gem/)

Please also add the following depending on the CI you are using.

### GitHub Actions
e.g.

```yml
- uses: actions/setup-go@v5
  with:
    go-version-file: ext/GEM_NAME/go.mod
```

## Developing
### Build
Run `rake ruby:build_dummy`. (`bundle exec` is not required)

See `rake -T` for more tasks.

### Add wrapper function for C
See [CONTRIBUTING.md](CONTRIBUTING.md)

### See `godoc` in local
```bash
go install golang.org/x/tools/cmd/godoc@latest
godoc
```

open http://localhost:6060/pkg/github.com/sue445/go-gem-wrapper/

## Coverage
This repository is currently in the development phase and does not yet implement all functions defined in `ruby.h`.

The following functions are currently supported.

<details>
  <summary>Display all</summary>

ref. https://docs.ruby-lang.org/ja/latest/function/index.html

* [ ] `rb_add_method`
* [x] `rb_alias`
* [ ] `rb_alias_variable`
* [ ] `rb_any_to_s`
* [ ] `rb_apply`
* [ ] `rb_Array`
* [ ] `rb_ary_aref`
* [ ] `rb_ary_clear`
* [ ] `rb_ary_concat`
* [ ] `rb_ary_delete`
* [ ] `rb_ary_entry`
* [ ] `rb_ary_includes`
* [ ] `rb_ary_new`
* [ ] `rb_ary_new2`
* [ ] `rb_ary_new3`
* [ ] `rb_ary_pop`
* [ ] `rb_ary_push`
* [ ] `rb_ary_shift`
* [ ] `rb_ary_sort`
* [ ] `rb_ary_store`
* [ ] `rb_ary_to_s`
* [ ] `rb_ary_unshift`
* [ ] `rb_assoc_new`
* [x] `rb_attr`
* [ ] `rb_autoload`
* [ ] `rb_autoload_defined`
* [ ] `rb_autoload_id`
* [ ] `rb_autoload_load`
* [ ] `rb_backref_error`
* [ ] `rb_backref_get`
* [ ] `rb_backref_set`
* [ ] `rb_backtrace`
* [x] `rb_block_given_p`
* [x] `rb_block_proc`
* [ ] `rb_call`
* [ ] `rb_call0`
* [ ] `rb_call_super`
* [ ] `rb_callcc`
* [ ] `rb_catch`
* [ ] `rb_check_convert_type`
* [x] `rb_class2name`
* [ ] `rb_class_allocate_instance`
* [ ] `rb_class_boot`
* [ ] `rb_class_inherited`
* [ ] `rb_class_initialize`
* [ ] `rb_class_instance_methods`
* [ ] `rb_class_new`
* [ ] `rb_class_new_instance`
* [ ] `rb_class_path`
* [ ] `rb_class_private_instance_methods`
* [ ] `rb_class_protected_instance_methods`
* [ ] `rb_class_real`
* [ ] `rb_class_s_new`
* [ ] `rb_class_superclass`
* [ ] `rb_clear_cache`
* [ ] `rb_clear_cache_by_class`
* [ ] `rb_clear_cache_by_id`
* [ ] `rb_compile_cstr`
* [ ] `rb_compile_error`
* [ ] `rb_compile_error_with_enc`
* [ ] `rb_compile_file`
* [ ] `rb_compile_string`
* [ ] `rb_const_assign`
* [x] `rb_const_defined`
* [ ] `rb_const_defined_at`
* [x] `rb_const_get`
* [ ] `rb_const_get_at`
* [ ] `rb_const_list`
* [x] `rb_const_set`
* [ ] `rb_cont_call`
* [ ] `rb_convert_type`
* [ ] `rb_copy_generic_ivar`
* [ ] `rb_cstr_to_dbl`
* [ ] `rb_cv_get`
* [ ] `rb_cv_set`
* [ ] `rb_cvar_declear`
* [ ] `rb_cvar_defined`
* [ ] `rb_cvar_get`
* [ ] `rb_cvar_set`
* [ ] `rb_data_object_alloc`
* [ ] `rb_define_alias`
* [ ] `rb_define_attr`
* [x] `rb_define_class`
* [ ] `rb_define_class_id`
* [x] `rb_define_class_under`
* [ ] `rb_define_class_variable`
* [ ] `rb_define_const`
* [ ] `rb_define_global_const`
* [ ] `rb_define_global_function`
* [ ] `rb_define_hooked_variable`
* [x] `rb_define_method`
* [ ] `rb_define_method_id`
* [x] `rb_define_module`
* [x] `rb_define_module_function`
* [ ] `rb_define_module_id`
* [x] `rb_define_module_under`
* [ ] `rb_define_private_method`
* [ ] `rb_define_protected_method`
* [ ] `rb_define_readonly_variable`
* [x] `rb_define_singleton_method`
* [ ] `rb_define_variable`
* [ ] `rb_define_virtual_variable`
* [ ] `rb_disable_super`
* [ ] `rb_dvar_curr`
* [ ] `rb_dvar_defined`
* [ ] `rb_dvar_push`
* [ ] `rb_dvar_ref`
* [ ] `rb_enable_super`
* [ ] `rb_ensure`
* [ ] `rb_eql`
* [ ] `rb_equal`
* [ ] `rb_eval`
* [ ] `rb_eval_cmd`
* [ ] `rb_eval_string`
* [ ] `rb_eval_string_protect`
* [ ] `rb_eval_string_wrap`
* [ ] `rb_exc_fatal`
* [ ] `rb_exc_raise`
* [ ] `rb_exec_end_proc`
* [ ] `rb_exit`
* [ ] `rb_export_method`
* [ ] `rb_extend_object`
* [ ] `rb_f_abort`
* [ ] `rb_f_array`
* [ ] `rb_f_at_exit`
* [ ] `rb_f_autoload`
* [ ] `rb_f_binding`
* [ ] `rb_f_block_given_p`
* [ ] `rb_f_caller`
* [ ] `rb_f_catch`
* [ ] `rb_f_END`
* [ ] `rb_f_eval`
* [ ] `rb_f_exit`
* [ ] `rb_f_float`
* [ ] `rb_f_global_variables`
* [ ] `rb_f_hash`
* [ ] `rb_f_integer`
* [ ] `rb_f_lambda`
* [ ] `rb_f_load`
* [ ] `rb_f_local_variables`
* [ ] `rb_f_loop`
* [ ] `rb_f_missing`
* [ ] `rb_f_raise`
* [ ] `rb_f_require`
* [ ] `rb_f_send`
* [ ] `rb_f_string`
* [ ] `rb_f_throw`
* [ ] `rb_f_trace_var`
* [ ] `rb_f_untrace_var`
* [ ] `rb_false`
* [ ] `rb_fatal`
* [ ] `rb_feature_p`
* [ ] `rb_fix_new`
* [ ] `rb_Float`
* [ ] `rb_frame_last_func`
* [ ] `rb_free_generic_ivar`
* [ ] `rb_frozen_class_p`
* ~~[ ] `rb_funcall`~~ Go's variable-length arguments couldn't be passed directly to C. See [CONTRIBUTING.md](CONTRIBUTING.md)
* [x] `rb_funcall2`
* [x] `rb_funcall3`
* [x] `rb_funcallv`
* [x] `rb_funcallv_public`
* [ ] `rb_gc`
* [ ] `rb_gc_call_finalizer_at_exit`
* [ ] `rb_gc_disable`
* [ ] `rb_gc_enable`
* [ ] `rb_gc_force_recycle`
* [ ] `rb_gc_mark`
* [ ] `rb_gc_mark_children`
* [ ] `rb_gc_mark_frame`
* [ ] `rb_gc_mark_global_tbl`
* [ ] `rb_gc_mark_locations`
* [ ] `rb_gc_mark_maybe`
* [ ] `rb_gc_mark_threads`
* [ ] `rb_gc_register_address`
* [ ] `rb_gc_start`
* [ ] `rb_gc_unregister_address`
* [ ] `rb_generic_ivar_table`
* [ ] `rb_get_method_body`
* [ ] `rb_global_entry`
* [ ] `rb_global_variable`
* [ ] `rb_gv_get`
* [ ] `rb_gv_set`
* [ ] `rb_gvar_defined`
* [ ] `rb_gvar_get`
* [ ] `rb_gvar_set`
* [ ] `rb_id2name`
* [ ] `rb_id_attrset`
* [ ] `rb_include_module`
* [ ] `rb_inspect`
* [ ] `rb_int_new`
* [ ] `rb_Integer`
* [x] `rb_int2num_inline`
* [x] `rb_intern`
* [ ] `rb_interrupt`
* [ ] `rb_io_mode_flags2`
* [ ] `rb_is_class_id`
* [ ] `rb_is_const_id`
* [ ] `rb_is_instance_id`
* [ ] `rb_is_local_id`
* [ ] `rb_iter_break`
* [ ] `rb_iterate`
* [ ] `rb_iterator_p`
* [ ] `rb_iv_get`
* [ ] `rb_iv_set`
* [ ] `rb_ivar_defined`
* [x] `rb_ivar_get`
* [x] `rb_ivar_set`
* [ ] `rb_jump_tag`
* [ ] `rb_lastline_get`
* [ ] `rb_lastline_set`
* [ ] `rb_load`
* [ ] `rb_load_protect`
* [x] `rb_long2num_inline`
* [ ] `rb_longjmp`
* [ ] `rb_make_metaclass`
* [ ] `rb_mark_end_proc`
* [ ] `rb_mark_generic_ivar`
* [ ] `rb_mark_generic_ivar_tbl`
* [ ] `rb_mark_hash`
* [ ] `rb_mark_tbl`
* [ ] `rb_memerror`
* [ ] `rb_method_boundp`
* [ ] `rb_mod_alias_method`
* [ ] `rb_mod_ancestors`
* [ ] `rb_mod_append_features`
* [ ] `rb_mod_attr`
* [ ] `rb_mod_attr_accessor`
* [ ] `rb_mod_attr_reader`
* [ ] `rb_mod_attr_writer`
* [ ] `rb_mod_class_variables`
* [ ] `rb_mod_clone`
* [ ] `rb_mod_cmp`
* [ ] `rb_mod_const_at`
* [ ] `rb_mod_const_defined`
* [ ] `rb_mod_const_get`
* [ ] `rb_mod_const_of`
* [ ] `rb_mod_const_set`
* [ ] `rb_mod_constants`
* [ ] `rb_mod_define_method`
* [ ] `rb_mod_dup`
* [ ] `rb_mod_eqq`
* [ ] `rb_mod_extend_object`
* [ ] `rb_mod_ge`
* [ ] `rb_mod_gt`
* [ ] `rb_mod_include`
* [ ] `rb_mod_include_p`
* [ ] `rb_mod_included_modules`
* [ ] `rb_mod_initialize`
* [ ] `rb_mod_le`
* [ ] `rb_mod_lt`
* [ ] `rb_mod_method`
* [ ] `rb_mod_method_defined`
* [ ] `rb_mod_modfunc`
* [ ] `rb_mod_module_eval`
* [ ] `rb_mod_name`
* [ ] `rb_mod_nesting`
* [ ] `rb_mod_private`
* [ ] `rb_mod_private_method`
* [ ] `rb_mod_protected`
* [ ] `rb_mod_public`
* [ ] `rb_mod_public_method`
* [ ] `rb_mod_remove_const`
* [ ] `rb_mod_remove_cvar`
* [ ] `rb_mod_remove_method`
* [ ] `rb_mod_s_constants`
* [ ] `rb_mod_to_s`
* [ ] `rb_mod_undef_method`
* [ ] `rb_module_new`
* [ ] `rb_module_s_alloc`
* [ ] `rb_name_class`
* [ ] `rb_newobj`
* [ ] `rb_node_newnode`
* [ ] `rb_num2dbl`
* [x] `rb_num2int_inline`
* [x] `rb_num2long`
* [ ] `rb_obj_alloc`
* [ ] `rb_obj_call_init`
* [ ] `rb_obj_class`
* [ ] `rb_obj_clone`
* [ ] `rb_obj_dummy`
* [ ] `rb_obj_dup`
* [ ] `rb_obj_equal`
* [ ] `rb_obj_extend`
* [ ] `rb_obj_freeze`
* [ ] `rb_obj_frozen_p`
* [ ] `rb_obj_id`
* [ ] `rb_obj_inspect`
* [ ] `rb_obj_instance_eval`
* [ ] `rb_obj_instance_variables`
* [ ] `rb_obj_is_block`
* [ ] `rb_obj_is_instance_of`
* [ ] `rb_obj_is_kind_of`
* [ ] `rb_obj_is_proc`
* [ ] `rb_obj_method`
* [ ] `rb_obj_methods`
* [ ] `rb_obj_private_methods`
* [ ] `rb_obj_protected_methods`
* [ ] `rb_obj_remove_instance_variable`
* [ ] `rb_obj_respond_to`
* [ ] `rb_obj_singleton_methods`
* [ ] `rb_obj_taint`
* [ ] `rb_obj_tainted`
* [ ] `rb_obj_untaint`
* [ ] `rb_p`
* [ ] `rb_parser_append_print`
* [ ] `rb_parser_while_loop`
* [ ] `rb_path2class`
* [ ] `rb_proc_new`
* [ ] `rb_protect`
* [ ] `rb_provide`
* [ ] `rb_provide_feature`
* [ ] `rb_provided`
* [x] `rb_raise`
* [ ] `rb_remove_method`
* [ ] `rb_require`
* [ ] `rb_rescue`
* [ ] `rb_rescue2`
* [ ] `rb_reserved_word`
* [ ] `rb_respond_to`
* [ ] `rb_safe_level`
* [ ] `rb_scan_args`
* [ ] `rb_secure`
* [ ] `rb_set_class_path`
* [ ] `rb_set_end_proc`
* [ ] `rb_set_safe_level`
* [ ] `rb_singleton_class`
* [ ] `rb_singleton_class_attached`
* [ ] `rb_singleton_class_clone`
* [ ] `rb_singleton_class_new`
* [ ] `rb_source_filename`
* [ ] `rb_str_cat`
* [ ] `rb_str_cat2`
* [ ] `rb_str_concat`
* [ ] `rb_str_dup`
* [ ] `rb_str_new`
* [ ] `rb_str_new2`
* [ ] `rb_str_new4`
* [ ] `rb_str_substr`
* [ ] `rb_str_to_dbl`
* [ ] `rb_String`
* [ ] `rb_svar`
* [ ] `rb_sym_all_symbols`
* [ ] `rb_sym_interned_p`
* [ ] `rb_thread_abort_exc`
* [ ] `rb_thread_abort_exc_set`
* [ ] `rb_thread_alive_p`
* [ ] `rb_thread_alloc`
* [ ] `rb_thread_alone`
* [ ] `rb_thread_aref`
* [ ] `rb_thread_aset`
* [ ] `rb_thread_atfork`
* [ ] `rb_thread_check`
* [ ] `rb_thread_cleanup`
* [ ] `rb_thread_create`
* [ ] `rb_thread_critical_get`
* [ ] `rb_thread_critical_set`
* [ ] `rb_thread_current`
* [ ] `rb_thread_dead`
* [ ] `rb_thread_deadlock`
* [ ] `rb_thread_exit`
* [ ] `rb_thread_fd_close`
* [ ] `rb_thread_fd_writable`
* [ ] `rb_thread_initialize`
* [ ] `rb_thread_inspect`
* [ ] `rb_thread_interrupt`
* [ ] `rb_thread_join`
* [ ] `rb_thread_join_m`
* [ ] `rb_thread_key_p`
* [ ] `rb_thread_keys`
* [ ] `rb_thread_kill`
* [ ] `rb_thread_list`
* [ ] `rb_thread_local_aref`
* [ ] `rb_thread_local_aset`
* [ ] `rb_thread_main`
* [ ] `rb_thread_pass`
* [ ] `rb_thread_priority`
* [ ] `rb_thread_priority_set`
* [ ] `rb_thread_raise`
* [ ] `rb_thread_raise_m`
* [ ] `rb_thread_ready`
* [ ] `rb_thread_remove`
* [ ] `rb_thread_restore_context`
* [ ] `rb_thread_run`
* [ ] `rb_thread_s_abort_exc`
* [ ] `rb_thread_s_abort_exc_set`
* [ ] `rb_thread_s_kill`
* [ ] `rb_thread_s_new`
* [ ] `rb_thread_safe_level`
* [ ] `rb_thread_save_context`
* [ ] `rb_thread_schedule`
* [ ] `rb_thread_signal_raise`
* [ ] `rb_thread_sleep`
* [ ] `rb_thread_sleep_forever`
* [ ] `rb_thread_start`
* [ ] `rb_thread_start_0`
* [ ] `rb_thread_start_timer`
* [ ] `rb_thread_status`
* [ ] `rb_thread_stop`
* [ ] `rb_thread_stop_p`
* [ ] `rb_thread_stop_timer`
* [ ] `rb_thread_trap_eval`
* [ ] `rb_thread_value`
* [ ] `rb_thread_wait_fd`
* [ ] `rb_thread_wait_for`
* [ ] `rb_thread_wait_other_threads`
* [ ] `rb_thread_wakeup`
* [ ] `rb_thread_yield`
* [ ] `rb_throw`
* [ ] `rb_time_timespec_new`
* [ ] `rb_timespec_now`
* [ ] `rb_to_id`
* [ ] `rb_to_int`
* [ ] `rb_to_integer`
* [ ] `rb_trace_eval`
* [ ] `rb_trap_eval`
* [ ] `rb_true`
* [ ] `rb_uint_new`
* [ ] `rb_undef`
* [ ] `rb_undef_method`
* [ ] `rb_undefined`
* [x] `rb_utf8_str_new`
* [ ] `rb_with_disable_interrupt`
* [x] `rb_yield`
* [ ] `rb_yield_0`
* [x] `RSTRING_PTR`
* [x] `RSTRING_LENINT`

</details>
