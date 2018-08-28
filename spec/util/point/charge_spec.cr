require "../spec_helper"

module SymmUtil
  describe Charge do
    it "does not invert state on inversion call" do
      vec = Vector3.new(0, 1, 2)
      point = Charge.new(vec, false)
      point.invert_state
      point.sign.should eq Sign::Minus
    end
  end
end
