# frozen_string_literal: true

RSpec.describe Dummy::Tests do
  describe "#rb_ivar_get" do
    it "works" do
      t = Dummy::Tests.new(2)
      expect(t.rb_ivar_get).to eq 2
    end
  end

  describe "#increment" do
    it "works" do
      unit = Dummy::Tests.new(1)
      actual = unit.increment

      expect(actual).to eq 2
      expect(unit.ivar).to eq 2
    end
  end
end
