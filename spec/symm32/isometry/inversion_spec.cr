require "../../spec_helper"

module Symm32
  describe Inversion do
    it "is a constant" do
      Isometry::INVERSION.should be_a Inversion
    end

    it "inverts" do
      vec = Vector3.new(1, 2, 3)
      Isometry::INVERSION.transform(vec).should eq Vector3.new(-1, -2, -3)
    end
  end
end
