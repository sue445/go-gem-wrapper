package ruby

/*
#include "ruby.h"
*/
import "C"

// RbAlias calls `rb_alias` in C
//
// Original definition is following
//
//	void rb_alias(VALUE klass, ID dst, ID src)
func RbAlias(klass VALUE, dst ID, src ID) {
	C.rb_alias(C.VALUE(klass), C.ID(dst), C.ID(src))
}

// RbAttr calls `rb_attr` in C
//
// Original definition is following
//
//	void rb_attr(VALUE klass, ID name, int need_reader, int need_writer, int honour_visibility)
func RbAttr(klass VALUE, name ID, needReader bool, needWriter bool, honourVisibility bool) {
	C.rb_attr(C.VALUE(klass), C.ID(name), C.int(Bool2Int(needReader)), C.int(Bool2Int(needWriter)), C.int(Bool2Int(honourVisibility)))
}
