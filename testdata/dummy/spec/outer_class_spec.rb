# frozen_string_literal: true

RSpec.describe "OuterClass" do
  it "should be defined" do
    expect(OuterClass).to be_a Class
  end
end
