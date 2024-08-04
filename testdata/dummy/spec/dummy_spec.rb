# frozen_string_literal: true

RSpec.describe Dummy do
  describe ".sum" do
    it "works" do
      actual = Dummy.sum(1, 2)
      expect(actual).to eq 3
    end
  end

  describe ".hello" do
    it "works" do
      actual = Dummy.hello("sue445")
      expect(actual).to eq "Hello, sue445"
    end
  end

  describe ".to_string" do
    it "works" do
      actual = Dummy.to_string(123)
      expect(actual).to eq "123"
    end
  end

  describe ".max" do
    context "a > b" do
      it "works" do
        actual = Dummy.max(3, 2)
        expect(actual).to eq 3
      end
    end

    context "a < b" do
      it "works" do
        actual = Dummy.max(1, 2)
        expect(actual).to eq 2
      end
    end
  end

  describe "#max" do
    include Dummy

    context "a > b" do
      it "works" do
        actual = max(3, 2)
        expect(actual).to eq 3
      end
    end

    context "a < b" do
      it "works" do
        actual = max(1, 2)
        expect(actual).to eq 2
      end
    end
  end
end
