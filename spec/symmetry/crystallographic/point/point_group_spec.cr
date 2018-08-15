require "../spec_helper"

module Symmetry
  module Crystallographic
    describe PointGroup do
      context "point group 2/m" do
        pg2m = PointGroup.parse("monoclinic", "2/m", ["e", "2z", "i", "mz"])

        it "has basic properties" do
          pg2m.family.should eq Family::Monoclinic
          pg2m.name.should eq "2/m"
        end

        it "has cardinality" do
          pg2m.cardinality[IsometryKind::Mirror].should eq 1
          pg2m.cardinality[IsometryKind::Identity].should eq 1
          pg2m.cardinality[IsometryKind::Rotation2].should eq 1
          pg2m.cardinality[IsometryKind::Inversion].should eq 1
        end

        it "has 1 direction" do
          pg2m.directions.size.should eq 1
        end

        it "has 4 isometries" do
          pg2m.isometries.size.should eq 4
        end

        it "selects a direction it has" do
          pg2m.select_direction(Axis::Z).should be_a Direction
        end

        it "doesn't select directions it doesn't have" do
          pg2m.select_direction(Axis::D1).should be_nil
        end

        it "selects a direction by vector" do
          vec = Vector3.new(0.0, 0.0, -1.0)
          pg2m.select_direction(vec).not_nil!.axis.should eq Axis::Z
        end

        it "selects directions given axes and sorts by enum" do
          axes = [Axis::D1, Axis::Z, Axis::Origin]
          pg2m.select_directions(axes).first.axis.should eq Axis::Z
        end

        it "selects directions perpendicular to an axis" do
          pg2m.directions_perp_to(Axis::T0).first.axis.should eq Axis::Z
        end

        it "has no plane, diags, or edges" do
          pg2m.plane.empty?.should be_true
          pg2m.diags.empty?.should be_true
          pg2m.edges.empty?.should be_true
        end
      end
    end
  end
end
