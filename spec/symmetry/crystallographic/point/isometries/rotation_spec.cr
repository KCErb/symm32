require "../../spec_helper"

module Symmetry
  module Crystallographic
    describe Rotation do
      it "is created in this way" do
        Rotation.new(Axis::Z, 3, 2)
      end

      it "inherits transform from parent" do
        Rotation.new(Axis::Z, 3, 2).responds_to?(:transform).should be_true
      end

      it "is one of the Rotation isometry kinds" do
        Rotation.new(Axis::Z, 3, 2).isometry_kind.should eq IsometryKind::Rotation3_2
      end
    end
  end
end
