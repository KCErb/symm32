require "../../spec_helper"

module Symmetry
  module Crystallographic
    describe Inversion do
      it "is a constant" do
        PointIsometry::INVERSION.should be_a Inversion
      end

      it "inherits transform from parent" do
        PointIsometry::INVERSION.responds_to?(:transform).should be_true
      end

      it "is an Inversion isometry kind" do
        PointIsometry::INVERSION.isometry_kind.should eq IsometryKind::Inversion
      end
    end
  end
end
