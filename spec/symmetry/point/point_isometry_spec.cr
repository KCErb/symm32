require "./spec_helper"

module Symmetry
  describe PointIsometry do
    it "test child transforms" do
      res = TestPointIsometry.new.transform(Vector3.new(1, 1, 1))
      res.should eq Vector3.new(3, 3, 3)
    end
  end
end
