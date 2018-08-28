require "../spec_helper"

module Symm32
  describe Identity do
    it "is a constant" do
      Isometry::IDENTITY.should be_a Identity
    end

    it "doesn't change points it is asked to transform" do
      vec = Vector3.new(1, 2, 3)
      point = TestPoint.new(vec)
      Isometry::IDENTITY.transform(point).should eq point
    end
  end
end
