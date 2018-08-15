require "./spec_helper"

module Symmetry
  describe PointGroup do
    it "can be created" do
      isometries = [] of PointIsometry
      isometries << TestPointIsometry.new
      isometries << TestCompoundPointIsometry.new
      group = TestPointGroup.new(isometries)
      group.isometries.should eq isometries
    end
  end
end
