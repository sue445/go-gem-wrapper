RSpec.describe RubyHToGo::StructDefinition do
  describe "#generate_go_content" do
    subject { RubyHToGo::StructDefinition.new(definition).generate_go_content }

    context "rb_data_type_struct" do
      let(:definition) do
        RubyHeaderParser::StructDefinition.new(
          name:     "rb_data_type_struct",
          filepath: "/path/to/include/ruby/internal/core/rtypeddata.h",
        )
      end

      let(:go_content) do
        <<~GO
          // RbDataTypeStruct is a type for passing `C.rb_data_type_struct` in and out of package
          type RbDataTypeStruct C.rb_data_type_struct

        GO
      end

      it { should eq go_content }
    end
  end
end
