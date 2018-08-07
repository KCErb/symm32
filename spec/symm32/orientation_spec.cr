require "../spec_helper"

module Symm32
  describe Orientation do
    it "can be created with a parent direction" do
      child = POINT_GROUPS["222"]
      parent = POINT_GROUPS["422"]
      parent_z = parent.directions.first
      o = Orientation.new(child, parent, parent_z)
      o.child.should eq child
      o.parent.should eq parent
    end

    it "can be created without a parent direction" do
      child = POINT_GROUPS["1b"]
      parent = POINT_GROUPS["222"]
      o = Orientation.new(child, parent)
      o.child.should eq child
      o.parent.should eq parent
    end

    it "returns classification for nil parent" do
      child = POINT_GROUPS["1b"]
      parent = POINT_GROUPS["222"]
      o = Orientation.new(child, parent)
      o.parent_classification.should eq CrystalFamily::Classification::None
    end

    it "returns classification for not-nil parent" do
      child = POINT_GROUPS["222"]
      parent = POINT_GROUPS["422"]
      parent_z = parent.directions.first
      o = Orientation.new(child, parent, parent_z)
      o.parent_classification.should eq CrystalFamily::Classification::Axial
    end

    it "maps child with no T plane" do
      child = POINT_GROUPS["m"]
      parent = POINT_GROUPS["mm2"]
      parent_z = parent.directions.first
      o = Orientation.new(child, parent, parent_z)
      o.map[child.directions.first].should eq parent_z
    end

    describe "#complete" do
      it "completes child with T plane" do
        child = POINT_GROUPS["222"]
        parent = POINT_GROUPS["422"]
        parent_z = parent.directions.first
        o = Orientation.new(child, parent, parent_z)
        parent_plane = parent.directions_perp_to(Axis::Z)
        o.complete([parent_plane[0], parent_plane[2]])
        o.map[child.plane.first].should eq parent_plane.first
        o.map[child.plane[1]].should eq parent_plane[2]
      end

      it "completes cubic child" do
        child = POINT_GROUPS["23"]
        parent = POINT_GROUPS["432"]
        parent_z = parent.directions.first
        o = Orientation.new(child, parent, parent_z)
        parent_plane = parent.directions_perp_to(Axis::Z)
        o.complete([parent_plane[0], parent_plane[2]])
        o.map[child.diags.first].should eq parent.diags.first
      end

      # in this special case, child plane can fit in this
      # special place, but the diags don't fit.
      it "marks as invalid if no good" do
        child = POINT_GROUPS["23"]
        parent = POINT_GROUPS["432"]
        parent_z = parent.directions.first
        parent_e1 = parent.edges.first
        parent_t90 = parent.plane[2]
        o = Orientation.new(child, parent, parent_z)
        o.complete([parent_e1, parent_t90])
        o.valid?.should be_false
      end
    end

    it "can be cloned" do
      child = POINT_GROUPS["222"]
      parent = POINT_GROUPS["422"]
      parent_z = parent.directions.first
      o = Orientation.new(child, parent, parent_z)
      o2 = o.clone
      child_z_direction = child.select_direction(Axis::Z).not_nil!
      o2.map[child_z_direction] = parent.directions[1]
      o.map[child_z_direction].should eq parent_z
    end

    describe "equality" do
      child = POINT_GROUPS["222"]
      parent = POINT_GROUPS["422"]
      parent_z = parent.directions.first
      o = Orientation.new(child, parent, parent_z)

      o2 = o.clone
      parent_plane = parent.directions_perp_to(Axis::Z)
      o.complete([parent_plane[0], parent_plane[2]])
      o2.complete([parent_plane[1], parent_plane[3]])

      parent = POINT_GROUPS["4/mmm"]
      o3 = Orientation.new(child, parent)

      it "generates unique fingerprints for unique orientations" do
        o.fingerprint.should_not eq o3.fingerprint
      end

      it "generates identical fingerprints for non-unique orientations" do
        o.fingerprint.should eq o2.fingerprint
      end

      it "determines equality same as fingerprints" do
        o.should eq o2
      end
    end
  end
end
