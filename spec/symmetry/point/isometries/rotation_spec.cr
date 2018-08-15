require "../../spec_helper"

module Symmetry
  describe Rotation do
    it "transforms given axis and angle" do
      ir = Rotation.new(Vector3.new(0, 1, 1), Math::PI/2)
      res = ir.transform(Vector3.new(0, 0, 1))
      res.should eq Vector3.new(1, 1, 1)
    end

    it "transforms given n-fold + power" do
      ir = Rotation.new(Vector3.new(0, 0, 1), 10, 2.5)
      res = ir.transform(Vector3.new(1, 0, 0))
      res.should eq Vector3.new(0, 1, 0)
    end
  end
end
