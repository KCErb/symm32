require "../spec_helper"

module SymmUtil
  describe Spin do
    it "does invert state on inversion call" do
      vec = Vector3.new(0, 1, 2)
      point = Spin.new(vec, false)
      point.invert_state
      point.handedness.should eq Handedness::Right
    end
  end
end
