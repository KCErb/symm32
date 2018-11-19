require "./spec_helper"

module Symm32
  describe Rotation do
    rot = Rotation.new(Axis::Z, 3, 2)

    it "returns the expected `kind` symbol" do
      rot.kind.should eq :rotation_3_2
    end

    it "transforms a point given n-fold + power" do
      vec = Vector3.new(1, 0, 0)
      point = ChiralPoint.new(vec)
      res = rot.transform(point)
      ans_vec = Vector3.new(-0.5, -Math.sqrt(3)/2, 0)
      ans = ChiralPoint.new(ans_vec)
      res.should eq ans
    end
  end
end
