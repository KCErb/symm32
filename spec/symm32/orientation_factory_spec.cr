require "../spec_helper"

module Symm32
  describe OrientationFactory do
    it "can be created" do
      child = POINT_GROUPS["222"]
      parent = POINT_GROUPS["422"]
      of = OrientationFactory.new(child, parent)
      of.child.should eq child
      of.parent.should eq parent
    end

    it "returns empty array if child cardinality simply does not fit" do
      child = POINT_GROUPS["1b"]
      parent = POINT_GROUPS["222"]

      factory = OrientationFactory.new(child, parent)
      orientations = factory.calculate_orientations
      orientations.size.should eq 0
    end

    it "returns orientation with empty map if child has no z" do
      child = POINT_GROUPS["1"]
      parent = POINT_GROUPS["222"]

      factory = OrientationFactory.new(child, parent)
      orientations = factory.calculate_orientations
      orientations.size.should eq 1
      orientations.first.map.empty?.should be_true
    end

    it "can calculate any orientation, some of these are tested in the point_groups test so..." do
      child = POINT_GROUPS["mm2"]
      parent = POINT_GROUPS["m3bm"]

      factory = OrientationFactory.new(child, parent)
      orientations = factory.calculate_orientations
      orientations.size.should eq 3

      child = POINT_GROUPS["6"]
      parent = POINT_GROUPS["622"]

      factory = OrientationFactory.new(child, parent)
      orientations = factory.calculate_orientations
      orientations.size.should eq 1
    end
  end
end
