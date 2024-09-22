// THE AUTOGENERATED LICENSE. ALL THE RIGHTS ARE RESERVED BY ROBOTS.

// WARNING: This file has automatically been generated
// Code generated by ruby_h_to_go. DO NOT EDIT.

package ruby

/*
#include "ruby.h"
*/
import "C"

// RbEncIsalnum calls `rb_enc_isalnum` in C
//
// Original definition is following
//
//	rb_enc_isalnum(OnigCodePoint c, rb_encoding *enc)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/encoding/ctype.h
func RbEncIsalnum(c Onigcodepoint, enc *RbEncoding) Bool {
	var cEnc C.rb_encoding
	ret := Bool(C.rb_enc_isalnum(C.OnigCodePoint(c), &cEnc))
	*enc = RbEncoding(cEnc)
	return ret
}

// RbEncIsalpha calls `rb_enc_isalpha` in C
//
// Original definition is following
//
//	rb_enc_isalpha(OnigCodePoint c, rb_encoding *enc)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/encoding/ctype.h
func RbEncIsalpha(c Onigcodepoint, enc *RbEncoding) Bool {
	var cEnc C.rb_encoding
	ret := Bool(C.rb_enc_isalpha(C.OnigCodePoint(c), &cEnc))
	*enc = RbEncoding(cEnc)
	return ret
}

// RbEncIsascii calls `rb_enc_isascii` in C
//
// Original definition is following
//
//	rb_enc_isascii(OnigCodePoint c, rb_encoding *enc)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/encoding/ctype.h
func RbEncIsascii(c Onigcodepoint, enc *RbEncoding) Bool {
	var cEnc C.rb_encoding
	ret := Bool(C.rb_enc_isascii(C.OnigCodePoint(c), &cEnc))
	*enc = RbEncoding(cEnc)
	return ret
}

// RbEncIscntrl calls `rb_enc_iscntrl` in C
//
// Original definition is following
//
//	rb_enc_iscntrl(OnigCodePoint c, rb_encoding *enc)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/encoding/ctype.h
func RbEncIscntrl(c Onigcodepoint, enc *RbEncoding) Bool {
	var cEnc C.rb_encoding
	ret := Bool(C.rb_enc_iscntrl(C.OnigCodePoint(c), &cEnc))
	*enc = RbEncoding(cEnc)
	return ret
}

// RbEncIsctype calls `rb_enc_isctype` in C
//
// Original definition is following
//
//	rb_enc_isctype(OnigCodePoint c, OnigCtype t, rb_encoding *enc)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/encoding/ctype.h
func RbEncIsctype(c Onigcodepoint, t Onigctype, enc *RbEncoding) Bool {
	var cEnc C.rb_encoding
	ret := Bool(C.rb_enc_isctype(C.OnigCodePoint(c), C.OnigCtype(t), &cEnc))
	*enc = RbEncoding(cEnc)
	return ret
}

// RbEncIsdigit calls `rb_enc_isdigit` in C
//
// Original definition is following
//
//	rb_enc_isdigit(OnigCodePoint c, rb_encoding *enc)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/encoding/ctype.h
func RbEncIsdigit(c Onigcodepoint, enc *RbEncoding) Bool {
	var cEnc C.rb_encoding
	ret := Bool(C.rb_enc_isdigit(C.OnigCodePoint(c), &cEnc))
	*enc = RbEncoding(cEnc)
	return ret
}

// RbEncIslower calls `rb_enc_islower` in C
//
// Original definition is following
//
//	rb_enc_islower(OnigCodePoint c, rb_encoding *enc)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/encoding/ctype.h
func RbEncIslower(c Onigcodepoint, enc *RbEncoding) Bool {
	var cEnc C.rb_encoding
	ret := Bool(C.rb_enc_islower(C.OnigCodePoint(c), &cEnc))
	*enc = RbEncoding(cEnc)
	return ret
}

// RbEncIsprint calls `rb_enc_isprint` in C
//
// Original definition is following
//
//	rb_enc_isprint(OnigCodePoint c, rb_encoding *enc)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/encoding/ctype.h
func RbEncIsprint(c Onigcodepoint, enc *RbEncoding) Bool {
	var cEnc C.rb_encoding
	ret := Bool(C.rb_enc_isprint(C.OnigCodePoint(c), &cEnc))
	*enc = RbEncoding(cEnc)
	return ret
}

// RbEncIspunct calls `rb_enc_ispunct` in C
//
// Original definition is following
//
//	rb_enc_ispunct(OnigCodePoint c, rb_encoding *enc)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/encoding/ctype.h
func RbEncIspunct(c Onigcodepoint, enc *RbEncoding) Bool {
	var cEnc C.rb_encoding
	ret := Bool(C.rb_enc_ispunct(C.OnigCodePoint(c), &cEnc))
	*enc = RbEncoding(cEnc)
	return ret
}

// RbEncIsspace calls `rb_enc_isspace` in C
//
// Original definition is following
//
//	rb_enc_isspace(OnigCodePoint c, rb_encoding *enc)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/encoding/ctype.h
func RbEncIsspace(c Onigcodepoint, enc *RbEncoding) Bool {
	var cEnc C.rb_encoding
	ret := Bool(C.rb_enc_isspace(C.OnigCodePoint(c), &cEnc))
	*enc = RbEncoding(cEnc)
	return ret
}

// RbEncIsupper calls `rb_enc_isupper` in C
//
// Original definition is following
//
//	rb_enc_isupper(OnigCodePoint c, rb_encoding *enc)
//
// ref. https://github.com/ruby/ruby/blob/master/include/ruby/internal/encoding/ctype.h
func RbEncIsupper(c Onigcodepoint, enc *RbEncoding) Bool {
	var cEnc C.rb_encoding
	ret := Bool(C.rb_enc_isupper(C.OnigCodePoint(c), &cEnc))
	*enc = RbEncoding(cEnc)
	return ret
}
