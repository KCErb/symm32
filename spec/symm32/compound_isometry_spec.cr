require "./spec_helper"

module Symm32
  describe CompoundIsometry do
    it "transforms a point based on children's combined rules" do
      comp = TestCompoundIsometry.new
      zero = Vector3.new(0, 0, 0)
      point = TestPoint.new(zero)
      res = comp.transform(point)
      ans_vec = Vector3.new(0, 0, 5)
      ans = TestPoint.new(ans_vec)
      res.should eq ans
    end

    it "it's an isometry" do
      CompoundIsometry.is_a? Isometry
    end
  end
end
