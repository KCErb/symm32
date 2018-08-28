require "../spec_helper"

module Symm32
  describe Inversion do
    it "is a constant" do
      Isometry::INVERSION.should be_a Inversion
    end

    it "inverts" do
      vec = Vector3.new(1, 2, 3)
      point = TestPoint.new(vec)
      ans_vec = Vector3.new(-1, -2, -3)
      ans = TestPoint.new(ans_vec, false)
      Isometry::INVERSION.transform(point).should eq ans
    end
  end
end
