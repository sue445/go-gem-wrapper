# frozen_string_literal: true

RSpec.describe "Dummy::InnerClass" do
  it "should be defined" do
    expect(Dummy::InnerClass).to be_a Class
  end
end
