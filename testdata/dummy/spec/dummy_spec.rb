# frozen_string_literal: true

RSpec.describe Dummy do
  describe ".sum" do
    it "works" do
      actual = Dummy.sum(1, 2)
      expect(actual).to eq 3
    end
  end
end
