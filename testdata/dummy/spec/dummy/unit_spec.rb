# frozen_string_literal: true

RSpec.describe Dummy::Unit do
  describe "#kilobyte" do
    it "works" do
      unit = Dummy::Unit.new(2)
      expect(unit.kilobyte).to eq 2048
    end
  end

  describe "#increment" do
    it "works" do
      unit = Dummy::Unit.new(1)
      actual = unit.increment

      expect(actual).to eq 2
      expect(unit.source).to eq 2
    end
  end
end
