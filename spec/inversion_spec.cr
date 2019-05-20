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

    it "inverts vectorlike" do
      inversion.transform({1, 2, 3}).should eq({-1, -2, -3})
    end

    it "does not invert vectorlike if chiral" do
      inversion.transform({1, 2, 3}, [:chiral]).should eq({1, 2, 3})
    end
  end
end
