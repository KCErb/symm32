require "../spec_helper"

module Symmetry
  describe Identity do
    it "is a constant" do
      PointIsometry::IDENTITY.should be_a Identity
    end

    it "doesn't change points it is asked to transform" do
      vec = Vector3.new(1, 2, 3)
      PointIsometry::IDENTITY.transform(vec).should eq vec
    end
  end
end
