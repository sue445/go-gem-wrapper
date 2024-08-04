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

  describe ".rb_yield" do
    context "with block" do
      it "works" do
        actual =
          Dummy::Tests.rb_yield(2) do |a|
            a * 3
          end

        expect(actual).to eq 6
      end
    end

    context "without block" do
      it "error" do
        expect { Dummy::Tests.rb_yield(2) }.to raise_error ArgumentError
      end
    end
  end
end
