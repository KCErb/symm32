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

    it "transforms vectorlike given n-fold + power" do
      res = ir.transform([1, 0, 0])
      res[0].should be_close(0.5, 2*Float64::EPSILON)
      res[1].should be_close(Math.sqrt(3)/2, Float64::EPSILON)
      res[2].should eq 0
    end

    it "transforms and inverts chiral vectorlike given n-fold + power" do
      res = ir.transform([1, 0, 0], [:chiral])
      res[0].should be_close(-0.5, 2*Float64::EPSILON)
      res[1].should be_close(-Math.sqrt(3)/2, Float64::EPSILON)
      res[2].should eq 0
    end
  end
end
