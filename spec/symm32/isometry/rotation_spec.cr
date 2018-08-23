require "../spec_helper"

module Symm32
  describe Rotation do
    it "transforms given n-fold + power" do
      ir = Rotation.new(Axis::Z, 3, 2)
      res = ir.transform(Vector3.new(1, 0, 0))
      ans = Vector3.new(-0.5, -Math.sqrt(3)/2, 0)
      res.close_to?(ans).should be_true
    end
  end
end
