require "./spec_helper"

module Symm32
  describe Identity do
    identity = PointIsometry.parse("e")

    it "returns the expected `kind` symbol" do
      identity.kind.should eq :identity
    end

    it "doesn't change points it is asked to transform" do
      vec = Vector3.new(1, 2, 3)
      point = ChiralPoint.new(vec)
      identity.transform(point).should eq point
    end
  end
end
