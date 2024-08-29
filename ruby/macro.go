package ruby

// NUM2LONG is alias to [RbNum2long]
func NUM2LONG(num VALUE) int64 {
	return RbNum2long(num)
}

// LONG2NUM is alias to [RbLong2numInline]
func LONG2NUM(v int64) VALUE {
	return RbLong2numInline(v)
}

// NUM2INT is alias to [RbNum2intInline]
func NUM2INT(x VALUE) int32 {
	return RbNum2intInline(x)
}

// INT2NUM is alias to [RbInt2numInline]
func INT2NUM(v int32) VALUE {
	return RbInt2numInline(v)
}

// RbFuncall2 is alias to [RbFuncallv]
func RbFuncall2(recv VALUE, mid ID, argc int32, argv []VALUE) VALUE {
	return RbFuncallv(recv, mid, argc, argv)
}

// RbFuncall3 is alias to [RbFuncallvPublic]
func RbFuncall3(recv VALUE, mid ID, argc int32, argv []VALUE) VALUE {
	return RbFuncallvPublic(recv, mid, argc, argv)
}
