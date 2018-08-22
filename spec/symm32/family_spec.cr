require "../spec_helper"

module Symm32
  describe Family do
    # Note, couldn't get before_each working properly
    # so dir1 and dir2 are recycled a bit awkwardly below
    it "classifies tetragonal families appropriately" do
      dir1 = Direction.new(Axis::Z, [ISO1, ISO4] of Isometry)
      dir2 = Direction.new(Axis::T90, [ISO2] of Isometry)
      dir1.classification.should eq AxisKind::None
      Family::Tetragonal.classify_directions([dir1])
      dir1.classification.should eq AxisKind::Axial
      dir2.classification.should eq AxisKind::None
      Family::Tetragonal.classify_directions([dir2])
      dir2.classification.should eq AxisKind::Planar
    end

    it "classifies hexagonal families appropriately" do
      dir1 = Direction.new(Axis::Z, [ISO1, ISO4] of Isometry)
      dir2 = Direction.new(Axis::T90, [ISO2] of Isometry)
      dir1.classification.should eq AxisKind::None
      Family::Hexagonal.classify_directions([dir1])
      dir1.classification.should eq AxisKind::Axial
      dir2.classification.should eq AxisKind::None
      Family::Hexagonal.classify_directions([dir2])
      dir2.classification.should eq AxisKind::Planar
    end

    it "classifies cubic families appropriately" do
      dir1 = Direction.new(Axis::Z, [ISO1, ISO4] of Isometry)
      dir3 = Direction.new(Axis::D1, [ISO5] of Isometry)
      dir1.classification.should eq AxisKind::None
      Family::Cubic.classify_directions([dir1])
      dir1.classification.should eq AxisKind::OnAxes
      dir3.classification.should eq AxisKind::None
      Family::Cubic.classify_directions([dir3])
      dir3.classification.should eq AxisKind::OffAxes
    end
  end
end
