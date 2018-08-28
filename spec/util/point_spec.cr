require "./spec_helper"

module SymmUtil
  describe TestPoint do
    it "is constructed with coordinates and state" do
      vec = Vector3.new(0, 1, 2)
      point = TestPoint.new(vec)
      point.x.should eq 0
      point.y.should eq 1
      point.z.should eq 2
      point.internal_state.should eq 1

      point = TestPoint.new(vec, false)
      point.internal_state.should eq 0
    end

    it "can have its state flipped by invert state" do
      vec = Vector3.new(0, 1, 2)
      point = TestPoint.new(vec, false)
      point.invert_state
      point.internal_state.should eq 1
    end
  end
end
