require "./spec_helper"

module Symm32
  describe PointGroup do
    context "point group 2/m" do
      pg2m = Symm32.point_group("2/m")

      it "has basic properties" do
        pg2m.family.should eq Family::Monoclinic
        pg2m.name.should eq "2/m"
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
        axes = [Axis::D1, Axis::Z, Axis::ORIGIN]
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

    # we'll check inverse and multiplication on a group where some
    # isometries are not their own inverse
    context "group operators" do
      pg1 = Symm32.point_group("1")
      pg4 = Symm32.point_group("4")
      identity = pg1.isometries.first
      pg4_isometries = pg4.isometries.to_a
      rot4 = pg4_isometries[1]
      rot2 = pg4_isometries[2]
      rot4_3 = pg4_isometries.last

      it "identity is own inverse" do
        pg1.inverse(identity).should eq identity
      end

      it "can handle isometry from other group" do
        pg4.inverse(identity).should eq identity
      end

      it "inverse of 4 is 4^3" do
        pg4.inverse(rot4).should eq rot4_3
      end

      it "inverse of 2 is 2 though" do
        pg4.inverse(rot2).should eq rot2
      end

      it "identity times anything is itself" do
        pg1.product(identity, identity).should eq identity
        pg4.product(identity, rot4_3).should eq rot4_3
        pg4.product(rot2, identity).should eq rot2
      end

      it "some other products" do
        pg4.product(rot4, rot4).should eq rot2
        pg4.product(rot4, rot4_3).should eq identity
        pg4.product(rot2, rot4).should eq rot4_3
      end

      # 32 is smallest non-abelian point group
      # note that several conventions come together to make the following result:
      # left action convention => AB means transform with B and then A
      # active rotations => rotate points, not coordinates
      # counter-clockwise is positive => rot3 => rotate point counter-clockwise 1/3 of the way
      context "non-abelian point group 32" do
        pg32 = Symm32.point_group("32")
        pg32_isometries = pg32.isometries.to_a
        # ["e", "3z", "3z^2", "2t30", "2t90", "2t150"]
        rot3 = pg32_isometries[1]
        rot2t30 = pg32_isometries[3]
        rot2t90 = pg32_isometries[4]
        rot2t150 = pg32_isometries[5]

        it "rot3 * rot2t30 = 2t90" do
          pg32.product(rot3, rot2t30).should eq rot2t90
        end

        it "rot2t30 * rot3 = 2t150" do
          pg32.product(rot2t30, rot3).should eq rot2t150
        end

        # paranoid, checking order of ops for array input of product
        it "rot2t30 * rot3 = 2t150" do
          pg32.product([rot2t150, rot2t30, rot3]).should eq identity
        end
      end
    end
  end
end
