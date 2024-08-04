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

  describe ".rb_block_proc" do
    context "with block" do
      it "works" do
        actual =
          Dummy::Tests.rb_block_proc(2) do |a|
            a * 3
          end

        expect(actual).to eq 6
      end
    end

    context "without block" do
      it "error" do
        expect { Dummy::Tests.rb_block_proc(2) }.to raise_error ArgumentError
      end
    end
  end

  describe ".rb_funcall2" do
    it "works" do
      actual = Dummy::Tests.rb_funcall2(15, -1)
      expect(actual).to eq 20
    end
  end

  describe ".rb_funcall3" do
    it "works" do
      actual = Dummy::Tests.rb_funcall3(15, -1)
      expect(actual).to eq 20
    end
  end
end
