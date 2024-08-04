# frozen_string_literal: true

RSpec.describe "Dummy::TestRbDefineClassUnder" do
  it "should be defined" do
    expect(Dummy::TestRbDefineClassUnder).to be_a Class
  end
end
