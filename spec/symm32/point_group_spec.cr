require "../spec_helper"

module Symm32
  describe PointGroup do

    # NOTE: this software is designed to load families, point groups, isometries
    # etc. all at once from a json file. Creating one of these in isolation
    # as in the below test may lead to unexpected results. These tests are for isolation
    # purposes, not demonstration purposes.
    context "point group 2/m" do
      pg2m = PointGroup.from_json(%({"name": "2/m", "isometries": ["e", "2z", "i", "mz"]}))

      it "has a name" do
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
        vec = Vector3.new(0.0,0.0,1.0)
        pg2m.select_direction(vec).not_nil!.axis.should eq Axis::Z
      end

      it "selects directions given axes and sorts by enum" do
        axes = [Axis::D1, Axis::Z, Axis::None]
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

      it "has dummy family by default!" do
        fam = pg2m.family
        fam.should be_a CrystalFamily
        fam.name.should eq "dummy"
      end
    end

    # check some specific trouble makers
    describe "#orientations_within" do
      it "can't perform this without family classification" do
        bad_pg = PointGroup.from_json(%({"name": "bad", "isometries": ["i"]}))
        bad_pg2 = PointGroup.from_json(%({"name": "bad", "isometries": ["m"]}))
        expect_raises(Exception, "Cannot calculate") do
          bad_pg.orientations_within(bad_pg2)
        end
      end

      it "222 fits within 4/mmm once" do
        orientations_count("222", "4/mmm").should eq 1
      end

      it "222 fits within m3b once" do
        orientations_count("222", "m3b").should eq 1
      end

      it "222 fits within 432 twice" do
        orientations_count("222", "432").should eq 2
      end

      it "23 fits within 432 once" do
        orientations_count("23", "432").should eq 1
      end

      it "23 fits within m3bm once" do
        orientations_count("23", "m3bm").should eq 1
      end

      it "4b2m fits within m3bm twice" do
        orientations_count("4b2m", "m3bm").should eq 2
      end

      it "m3b does not fit within 432" do
        orientations_count("m3b", "432").should eq 0
      end
    end
  end
end
