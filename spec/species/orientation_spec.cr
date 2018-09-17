require "./spec_helper"

module Symm32
  describe Orientation do
    it "can be created with a parent direction" do
      child = Symm32.point_group("222")
      parent = Symm32.point_group("422")
      parent_z = parent.directions.first
      o = Orientation.new(child, parent, parent_z)
      o.child.should eq child
      o.parent.should eq parent
    end

    it "can be created without a parent direction" do
      child = Symm32.point_group("1b")
      parent = Symm32.point_group("222")
      o = Orientation.new(child, parent)
      o.child.should eq child
      o.parent.should eq parent
    end

    it "returns classification for nil parent" do
      child = Symm32.point_group("1b")
      parent = Symm32.point_group("222")
      o = Orientation.new(child, parent)
      o.axis_classification.should eq AxisKind::None
    end

    it "returns classification for not-nil parent" do
      child = Symm32.point_group("222")
      parent = Symm32.point_group("422")
      parent_z = parent.directions.first
      o = Orientation.new(child, parent, parent_z)
      o.axis_classification.should eq AxisKind::Axial
    end

    it "maps child with no T plane" do
      child = Symm32.point_group("m")
      parent = Symm32.point_group("mm2")
      parent_z = parent.directions.first
      o = Orientation.new(child, parent, parent_z)
      o.correspondence[child.directions.first].should eq parent_z
    end

    describe "#complete" do
      it "completes child with T plane" do
        child = Symm32.point_group("222")
        parent = Symm32.point_group("422")
        parent_z = parent.directions.first
        o = Orientation.new(child, parent, parent_z)
        parent_plane = parent.directions_perp_to(Axis::Z)
        o.complete([parent_plane[0], parent_plane[2]])
        o.correspondence[child.plane.first].should eq parent_plane.first
        o.correspondence[child.plane[1]].should eq parent_plane[2]
      end

      it "completes cubic child" do
        child = Symm32.point_group("23")
        parent = Symm32.point_group("432")
        parent_z = parent.directions.first
        o = Orientation.new(child, parent, parent_z)
        parent_plane = parent.directions_perp_to(Axis::Z)
        o.complete([parent_plane[0], parent_plane[2]])
        o.correspondence[child.diags.first].should eq parent.diags.first
      end

      # in this special case, child plane can fit in this
      # special place, but the diags don't fit.
      it "marks as invalid if no good" do
        child = Symm32.point_group("23")
        parent = Symm32.point_group("432")
        parent_z = parent.directions.first
        parent_e1 = parent.edges.first
        parent_t90 = parent.plane[2]
        o = Orientation.new(child, parent, parent_z)
        o.complete([parent_e1, parent_t90])
        o.valid?.should be_false
      end
    end

    it "can be cloned" do
      child = Symm32.point_group("222")
      parent = Symm32.point_group("422")
      parent_z = parent.directions.first
      o = Orientation.new(child, parent, parent_z)
      o2 = o.clone
      child_z_direction = child.select_direction(Axis::Z).not_nil!
      o2.correspondence[child_z_direction] = parent.directions[1]
      o.correspondence[child_z_direction].should eq parent_z
    end

    describe "equality" do
      child = Symm32.point_group("222")
      parent = Symm32.point_group("422")
      parent_z = parent.directions.first
      o = Orientation.new(child, parent, parent_z)

      o2 = o.clone
      parent_plane = parent.directions_perp_to(Axis::Z)
      o.complete([parent_plane[0], parent_plane[2]])
      o2.complete([parent_plane[1], parent_plane[3]])

      parent = Symm32.point_group("4/mmm")
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
