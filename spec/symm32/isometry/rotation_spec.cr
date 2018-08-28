require "../spec_helper"

module Symm32
  describe Rotation do
    it "transforms given n-fold + power" do
      ir = Rotation.new(Axis::Z, 3, 2)
      vec = Vector3.new(1, 0, 0)
      point = TestPoint.new(vec)
      res = ir.transform(point)
      ans_vec = Vector3.new(-0.5, -Math.sqrt(3)/2, 0)
      ans = TestPoint.new(ans_vec)
      res.should eq ans
    end
  end
end
