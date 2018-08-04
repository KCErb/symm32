require "../spec_helper"

module Symm32
  class Foo
    include Cardinality(Foo)
    getter isometries : Array(Isometry)

    def initialize(@isometries)
      @cardinality = init_cardinality
    end
  end

  foo1 = Foo.new(ISOMETRIES1)
  foo2 = Foo.new(ISOMETRIES2)
  foo3 = Foo.new(ISOMETRIES3)

  describe "Class that includes Cardinality" do
    it "computes cardinality correctly" do
      foo1.cardinality[IsometryKind::Mirror].should eq 2
      foo2.cardinality[IsometryKind::Mirror].should eq 1
    end

    it "#fits_within when true" do
      foo2.fits_within?(foo1).should be_true
    end

    it "#fits_within when false" do
      foo1.fits_within?(foo2).should be_false
    end
  end

  describe Cardinality do
    describe "#count_fits" do
      it "has 1 fit when child is empty" do
        empty = Hash(IsometryKind, UInt8).new
        Cardinality.count_fits(empty, foo2.cardinality).should eq 1
      end

      it "has 0 fits when child does not fit" do
        Cardinality.count_fits(foo1.cardinality, foo2.cardinality).should eq 0
      end

      it "has 1 fit when child fits one way" do
        Cardinality.count_fits(foo3.cardinality, foo2.cardinality).should eq 1
      end

      it "has 2 fits when child fits two ways" do
        Cardinality.count_fits(foo2.cardinality, foo1.cardinality).should eq 2
      end

      it "flattens arrays of isometries and computes on them too" do
        Cardinality.count_fits_arr([foo2, foo3], [foo1]).should eq 1
      end
    end
  end
end
