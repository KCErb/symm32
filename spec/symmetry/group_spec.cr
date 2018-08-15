require "../spec_helper"

module Symmetry
  describe Group do
    it "can be created" do
      isometries = [] of Isometry
      isometries << TestIsometry.new
      isometries << TestCompoundIsometry.new
      group = TestGroup.new(isometries)
      group.isometries.should eq isometries
    end
  end
end
