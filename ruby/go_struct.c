#include "ruby.h"

void goobj_retain(void *);
void goobj_free(void *);

static const rb_data_type_t go_type = {
    "GoStruct",
    {NULL, goobj_free, NULL},
    0, 0, RUBY_TYPED_FREE_IMMEDIATELY|RUBY_TYPED_WB_PROTECTED
};

VALUE
NewGoStruct(VALUE klass, void *p)
{
    goobj_retain(p);
    return TypedData_Wrap_Struct((klass), &go_type, p);
}

void *
GetGoStruct(VALUE obj)
{
    void *val;
    return TypedData_Get_Struct((obj), void *, &go_type, (val));
}
