# frozen_string_literal: true

RSpec.describe "Dummy::InnerModule" do
  it "should be defined" do
    expect(Dummy::InnerModule).to be_a Module
  end
end
