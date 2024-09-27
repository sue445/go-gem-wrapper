# frozen_string_literal: true

RSpec.describe RubyHToGo::EnumDefinition do
  describe "#generate_go_content" do
    subject { RubyHToGo::EnumDefinition.new(definition:).generate_go_content }

    context "rb_data_type_struct" do
      let(:definition) do
        RubyHeaderParser::EnumDefinition.new(
          name:   "ruby_value_type",
          values: %w[RUBY_T_ARRAY RUBY_T_BIGNUM],
        )
      end

      let(:go_content) do
        <<~GO
          // RubyValueType is a type for passing `C.ruby_value_type` in and out of package
          type RubyValueType int

          // RubyValueType enumeration
          const (
          RUBY_T_ARRAY RubyValueType = C.RUBY_T_ARRAY
          RUBY_T_BIGNUM RubyValueType = C.RUBY_T_BIGNUM
          )

        GO
      end

      it { should eq go_content }
    end
  end
end
