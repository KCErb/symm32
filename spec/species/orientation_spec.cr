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

    it "returns axial classification for nil parent" do
      child = Symm32.point_group("1b")
      parent = Symm32.point_group("222")
      o = Orientation.new(child, parent)
      o.axis_classification.should eq AxisKind::None
      o.plane_classification.should eq AxisKind::None
    end

    it "returns plane classifications for parent 422" do
      child = Symm32.point_group("222")
      parent = Symm32.point_group("422")
      parent_z = parent.directions.first
      o = Orientation.new(child, parent, parent_z)
      t0_t90 = [parent.directions[1], parent.directions[3]]
      o.complete(t0_t90)
      o.plane_classification.should eq AxisKind::Planar
    end

    it "maps child with no T plane" do
      child = Symm32.point_group("m")
      parent = Symm32.point_group("mm2")
      parent_z = parent.directions.first
      o = Orientation.new(child, parent, parent_z)
      o.correspondence[child.directions.first].should eq parent_z
    end

    describe "#child_name" do
      it "determines child_name for species 4" do
        species = Symm32.species(4)
        species.orientation.child_name.should eq "m"
      end

      it "determines child_name for species 27" do
        species = Symm32.species(27)
        species.orientation.child_name.should eq "m|"
      end

      it "determines child_name for species 154" do
        species = Symm32.species(154)
        species.orientation.child_name.should eq "mm2++"
      end
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
        # check classification too
        o.plane_classification.should eq AxisKind::Planar
      end

      it "completes cubic child" do
        child = Symm32.point_group("23")
        parent = Symm32.point_group("432")
        parent_z = parent.directions.first
        o = Orientation.new(child, parent, parent_z)
        parent_plane = parent.directions_perp_to(Axis::Z)
        o.complete([parent_plane[0], parent_plane[2]])
        o.correspondence[child.diags.first].should eq parent.diags.first
        # check classification too
        o.plane_classification.should eq AxisKind::OnAxes
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

    describe "subset?" do
      it "can determine subsets correctly for 4/mmm => 2/m" do
        parent = Symm32.species(51) # 4/mmm => 4/m
        child = Symm32.species(58)  # 4/mmm => 2/m|
        child.orientation.subset?(parent.orientation).should be_true
        child = Symm32.species(59) # 4/mmm => 2/m_
        child.orientation.subset?(parent.orientation).should be_false
      end

      it "can determine subsets correctly for m3bm" do
        parent = Symm32.species(185) # m3bm => 3bm
        child = Symm32.species(188)  # m3bm => 3b
        child.orientation.subset?(parent.orientation).should be_true
        child = Symm32.species(206) # 4/mmm => 2\/m
        child.orientation.subset?(parent.orientation).should be_true
        child = Symm32.species(207) # 4/mmm => m+ - interesting no?
        child.orientation.subset?(parent.orientation).should be_false
      end
    end

    # Util methods
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
