require "../spec_helper"

class Foo
  include Symm32::Cardinality(Foo)
  @isometries : Array(Symm32::Isometry)

  def initialize
    iso1 = Symm32::Isometry.new(Symm32::IsometryKind::Mirror, Symm32::Axis::Z)
    iso2 = Symm32::Isometry.new(Symm32::IsometryKind::Rotation2, Symm32::Axis::T0)
    iso3 = Symm32::Isometry.new(Symm32::IsometryKind::Mirror, Symm32::Axis::T90)
    @isometries = [iso1, iso2, iso3]
    @cardinality = init_cardinality
  end
end

foo_test = Foo.new

describe "Class that includes Cardinality" do
  it "computes cardinality correctly" do
    foo_test.cardinality[Symm32::IsometryKind::Mirror].should eq 2
    foo_test.cardinality[Symm32::IsometryKind::Rotation2].should eq 1
  end

  pending "#fits_within when true" do
  end
  pending "#fits_within when false" do
  end
end

describe Symm32::Cardinality do
  pending "computes cardinality of isometry array" do
  end

  describe "#count_fits" do
    pending "has 1 fit when child is empty" do
    end

    pending "has 0 fits when child does not fit" do
    end

    pending "has 1 fit when child fits one way" do
    end

    pending "has 2 fits when child fits two ways" do
    end

    pending "flattens arrays of isometries and computes on them too" do
    end
  end
end
