# frozen_string_literal: true

RSpec.describe Dummy do
  describe ".sum" do
    it "works" do
      actual = Dummy.sum(1, 2)
      expect(actual).to eq 3
    end
  end

  describe ".with_block" do
    context "with block" do
      it "works" do
        actual =
          Dummy.with_block(2) do |a|
            a * 3
          end

        expect(actual).to eq 6
      end
    end

    context "without block" do
      it "error" do
        expect { Dummy.with_block(2) }.to raise_error ArgumentError
      end
    end
  end
end
