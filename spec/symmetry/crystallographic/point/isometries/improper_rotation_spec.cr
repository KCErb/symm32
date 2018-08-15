require "../../spec_helper"

module Symmetry
  module Crystallographic
    describe ImproperRotation do
      it "is created in this way" do
        ImproperRotation.new(Axis::Z, 3, 2)
      end

      it "inherits transform from parent" do
        ImproperRotation.new(Axis::Z, 3, 2).responds_to?(:transform).should be_true
      end

      it "is one of the ImproperRotation isometry kinds" do
        ImproperRotation.new(Axis::Z, 3, 2).isometry_kind.should eq IsometryKind::ImproperRotation3_2
      end
    end
  end
end
