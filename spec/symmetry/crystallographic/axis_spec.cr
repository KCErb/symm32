require "./spec_helper"

module Symmetry
  module Crystallographic
    describe Axis do
      it "is an enum" do
        Axis::Z.value.should eq 1
        Axis.parse("z").should eq Axis::Z
      end

      it "has special orthogonal method" do
        Axis::D2.orthogonal.should eq [Axis::E4, Axis::E1, Axis::T45]
      end

      it "forwards missing methods to Vector3" do
        Axis::Z.values.should eq({0.0, 0.0, 1.0})
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

      it "has correct values for some example cases" do
        diff = (Axis::T45.x - Math.sqrt(2)/2).abs
        (diff < Float64::EPSILON).should be_true
        diff = (Axis::T45.y - Math.sqrt(2)/2).abs
        (diff < Float64::EPSILON).should be_true
        (Axis::T45.z < Float64::EPSILON).should be_true
      end
    end
  end
end
