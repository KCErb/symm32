require "../spec_helper"

module Symmetry
  describe Isometry do
    it "test child transforms" do
      res = TestIsometry.new.transform(Vector3.new(0, 0, 0))
      res.should eq Vector3.new(0, 0, 3)
    end
  end
end
