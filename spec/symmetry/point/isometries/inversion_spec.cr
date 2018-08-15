require "../../spec_helper"

module Symmetry
  describe Inversion do
    it "is a constant" do
      PointIsometry::INVERSION.should be_a Inversion
    end

    it "inverts" do
      vec = Vector3.new(1, 2, 3)
      PointIsometry::INVERSION.transform(vec).should eq Vector3.new(-1, -2, -3)
    end
  end
end
