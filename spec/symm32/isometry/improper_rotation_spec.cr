require "../spec_helper"

module Symm32
  describe ImproperRotation do
    it "transforms given n-fold + power" do
      ir = ImproperRotation.new(Axis::Z, 3, 2)
      x_axis = Vector3.new(1, 0, 0)
      point = TestPoint.new(x_axis)
      res = ir.transform(point)
      ans_vec = Vector3.new(0.5, Math.sqrt(3)/2, 0)
      ans = TestPoint.new(ans_vec, false)
      res.should eq ans
    end
  end
end
