# frozen_string_literal: true

RSpec.describe Dummy::Tests do
  describe "#rb_ivar_get" do
    it "works" do
      t = Dummy::Tests.new(2)
      expect(t.rb_ivar_get).to eq 2
    end
  end

  describe "#rb_ivar_set" do
    it "works" do
      t = Dummy::Tests.new
      t.rb_ivar_set(10)
      expect(t.ivar).to eq 10
    end
  end
end
