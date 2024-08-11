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

  describe ".rb_alias" do
    after do
      Dummy::Tests.class_eval do
        remove_method :rb_ivar_get_alias if method_defined?(:rb_ivar_get_alias)
      end
    end

    it "works" do
      Dummy::Tests.rb_alias("rb_ivar_get_alias", "rb_ivar_get")
      t = Dummy::Tests.new
      expect(t).to be_respond_to :rb_ivar_get_alias
    end
  end

  describe ".rb_class2name" do
    it "works" do
      expect(Dummy::Tests.rb_class2name).to eq "Dummy::Tests"
    end
  end

  describe ".rb_attr" do
    after do
      Dummy::Tests.class_eval do
        remove_method :ivar2 if method_defined?(:ivar2)
        remove_method :ivar2= if method_defined?(:ivar2=)
      end
    end

    context "when attr_reader" do
      it "works" do
        Dummy::Tests.rb_attr(1, 0, 0)

        t = Dummy::Tests.new
        expect(t).to be_respond_to :ivar2
        expect(t).not_to be_respond_to :ivar2=
      end
    end

    context "when attr_writer" do
      it "works" do
        Dummy::Tests.rb_attr(0, 1, 0)

        t = Dummy::Tests.new
        expect(t).not_to be_respond_to :ivar2
        expect(t).to be_respond_to :ivar2=
      end
    end

    context "when attr_accessor" do
      it "works" do
        Dummy::Tests.rb_attr(1, 1, 0)

        t = Dummy::Tests.new
        expect(t).to be_respond_to :ivar2
        expect(t).to be_respond_to :ivar2=
      end
    end
  end
end
