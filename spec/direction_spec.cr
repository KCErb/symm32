require "./spec_helper"

module Symm32
  describe Direction do
    it "can be made" do
      d = Direction.new(Axis::Z, ISOMETRIES1)
      d.axis.should eq Axis::Z
      d.isometries.should eq ISOMETRIES1
      d.classification = AxisKind::OnAxes
      d.kinds.should eq Set{:identity, :mirror, :rotation_2}
    end

    it "can be cloned" do
      d = Direction.new(Axis::Z, ISOMETRIES1)
      d2 = d.clone
      d2.axis.should eq d.axis
      d2.isometries.should eq d.isometries
      d2.classification.should eq d.classification
    end
  end
end
