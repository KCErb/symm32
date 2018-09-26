require "./spec_helper"

module Symm32
  describe ImproperRotation do
    ir = ImproperRotation.new(Axis::Z, 3, 2)

    it "returns the expected `kind` symbol" do
      ir.kind.should eq :improper_rotation_3_2
    end

    it "transforms given n-fold + power" do
      x_axis = Vector3.new(1, 0, 0)
      point = ChiralPoint.new(x_axis)
      res = ir.transform(point)
      ans_vec = Vector3.new(0.5, Math.sqrt(3)/2, 0)
      ans = ChiralPoint.new(ans_vec)
      ans.invert(:chirality)
      res.should eq ans
    end
  end
end
