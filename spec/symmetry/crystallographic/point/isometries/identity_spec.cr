require "../../spec_helper"

module Symmetry
  module Crystallographic
    describe Identity do
      it "is a constant" do
        PointIsometry::IDENTITY.should be_a Identity
      end

      it "inherits transform from parent" do
        PointIsometry::IDENTITY.responds_to?(:transform).should be_true
      end

      it "is an Identity isometry kind" do
        PointIsometry::IDENTITY.isometry_kind.should eq IsometryKind::Identity
      end
    end
  end
end
