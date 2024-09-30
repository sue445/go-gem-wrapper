package ruby

/*
#include "ruby.h"
*/
import "C"

// StructStHashType is a type for passing `C.struct_st_hash_type` in and out of package
type StructStHashType C.struct_st_hash_type

// StHashType is alias to [StructStHashType]
type StHashType StructStHashType
