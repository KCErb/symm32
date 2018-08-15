require "../../spec_helper"

module Symmetry
  module Crystallographic
    describe Mirror do
      it "is created in this way" do
        Mirror.new(Axis::Z)
      end

      it "inherits transform from parent" do
        Mirror.new(Axis::Z).responds_to?(:transform).should be_true
      end

      it "is one of the Mirror isometry kinds" do
        Mirror.new(Axis::Z).isometry_kind.should eq IsometryKind::Mirror
      end
    end
  end
end
