require "./spec_helper"

module Symm32
  describe Mirror do
    m = Mirror.new(Axis::D1)

    it "returns the expected `kind` symbol" do
      m.kind.should eq :mirror
    end

    it "mirrors through given axis" do
      vec = Vector3.new(1, 1, 1)
      point = ChiralPoint.new(vec)
      res = m.transform(point)
      ans_vec = Vector3.new(-1, -1, -1)
      ans = ChiralPoint.new(ans_vec)
      ans.invert(:chirality)
      res.should eq ans
    end

    it "mirror acts on vectorlike" do
      vec = Vector3.new(1, 1, 1)
      point = ChiralPoint.new(vec)
      res = m.transform({1, 1, 1})
      res[0].should be_close(-1, 2*Float64::EPSILON)
      res[1].should be_close(-1, 2*Float64::EPSILON)
      res[2].should be_close(-1, 2*Float64::EPSILON)
    end

    it "mirror inverts if vectorlike is 'chiral'" do
      vec = Vector3.new(1, 1, 1)
      point = ChiralPoint.new(vec)
      res = m.transform({1, 1, 1}, [:chiral])
      res[0].should be_close(1, 2*Float64::EPSILON)
      res[1].should be_close(1, 2*Float64::EPSILON)
      res[2].should be_close(1, 2*Float64::EPSILON)
    end
  end
end
