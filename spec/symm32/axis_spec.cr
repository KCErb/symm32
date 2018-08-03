require "../spec_helper"

module Symm32
  describe Axis do
    it "stores some basic info about axes" do
      Axis::Z.cartesian.should eq Vector3.new(0.0,0.0,1.0)
      Axis::T90.spherical.should eq Vector3.new(1.0, Math::PI / 2.0, Math::PI / 2.0)
      Axis::D2.orthogonal.should eq [Axis::E4, Axis::E1, Axis::T45]
    end

    it "introspects on axis 'type'" do
      Axis::Z.planar?.should be_false
      Axis::T135.planar?.should be_true
      Axis::E1.edge?.should be_true
      Axis::D3.diagonal?.should be_true
    end

    it "calculates angles between axes" do
      Axis::Z.angle_from(Axis::D1).should eq 0.9553166181245092
    end

    # yeah, these might be a code smell...
    describe "special properties" do
      it "planar have special angle prop" do
        rad60 = 60 * Math::PI/180
        Axis::T60.angle.should eq rad60
      end

      it "non planar raise error on angle prop" do
        expect_raises(Exception, "No angle for: `Z`") do
          Axis::Z.angle
        end
      end

      it "some have special arg_int prop" do
        Axis::T150.arg_int.should eq 150_u8
      end

      it "rest raise error on arg_int prop" do
        expect_raises(Exception, "Can't call arg_int on `Z`") do
          Axis::Z.arg_int
        end
      end
    end
  end
end
