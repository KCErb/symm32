require "../spec_helper"

module Symm32
  describe Rotation do
    it "transforms a point given n-fold + power" do
      rot = Rotation.new(Axis::Z, 3, 2)
      vec = Vector3.new(1, 0, 0)
      point = TestPoint.new(vec)
      res = rot.transform(point)
      ans_vec = Vector3.new(-0.5, -Math.sqrt(3)/2, 0)
      ans = TestPoint.new(ans_vec)
      res.should eq ans
    end

    it "transforms vector at an arbitrary angle" do
      rot = Rotation.new(Axis::E2, Math::PI)
      vec = Vector3.new(0, 0, 1)
      rot.transform(vec).should eq Vector3.new(0, 1, 0)
    end
  end
end
