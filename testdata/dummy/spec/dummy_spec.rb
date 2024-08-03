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

  describe ".with_block2" do
    context "with block" do
      it "works" do
        actual =
          Dummy.with_block2(2) do |a|
            a * 3
          end

        expect(actual).to eq 6
      end
    end

    context "without block" do
      it "error" do
        expect { Dummy.with_block2(2) }.to raise_error ArgumentError
      end
    end
  end

  describe ".hello" do
    it "works" do
      actual = Dummy.hello("sue445")
      expect(actual).to eq "Hello, sue445"
    end
  end

  describe ".round_num2" do
    it "works" do
      actual = Dummy.round_num2(15, -1)
      expect(actual).to eq 20
    end
  end

  describe ".round_num3" do
    it "works" do
      actual = Dummy.round_num3(15, -1)
      expect(actual).to eq 20
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
