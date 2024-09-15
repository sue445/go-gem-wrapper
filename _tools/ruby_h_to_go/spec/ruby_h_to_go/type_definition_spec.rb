# frozen_string_literal: true
RSpec.describe RubyHToGo::TypeDefinition do
  describe "#generate_go_content" do
    subject { RubyHToGo::TypeDefinition.new(definition).generate_go_content }

    context "rb_data_type_struct" do
      let(:definition) do
        RubyHeaderParser::TypeDefinition.new(
          name:     "VALUE",
          filepath: "/path/to/include/ruby/internal/value.h",
        )
      end

      let(:go_content) do
        <<~GO
          // VALUE is a type for passing `C.VALUE` in and out of package
          type VALUE C.VALUE

        GO
      end

      it { should eq go_content }
    end
  end
end
