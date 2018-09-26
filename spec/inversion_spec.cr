require "./spec_helper"

module Symm32
  describe Inversion do
    inversion = PointIsometry.parse("i")

    it "returns the expected `kind` symbol" do
      inversion.kind.should eq :inversion
    end

    it "inverts" do
      vec = Vector3.new(1, 2, 3)
      point = ChiralPoint.new(vec)
      ans_vec = Vector3.new(-1, -2, -3)
      ans = ChiralPoint.new(ans_vec)
      ans.invert(:chirality)
      inversion.transform(point).should eq ans
    end
  end
end
