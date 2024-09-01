package ruby_test

import (
	"github.com/stretchr/testify/assert"
	"github.com/sue445/go-gem-wrapper/ruby"
	"testing"
)

func TestByte2String(t *testing.T) {
	type args struct {
		b []byte
	}
	tests := []struct {
		name string
		args args
		want string
	}{
		{
			name: "ABC",
			args: args{
				b: []byte{"A"[0], "B"[0], "C"[0], 0},
			},
			want: "ABC",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := ruby.Byte2String(&tt.args.b[0])
			assert.Equal(t, tt.want, got)
		})
	}
}
