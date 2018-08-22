require "../spec_helper"

module Symm32
  describe CompoundIsometry do
    it "transforms a point based on children's combined rules" do
      comp = TestCompoundIsometry.new
      zero = Vector3.new(0, 0, 0)
      res = comp.transform(zero)
      res.should eq Vector3.new(0, 0, 6)
    end

    it "it's an isometry" do
      CompoundIsometry.is_a? Isometry
    end
  end
end
