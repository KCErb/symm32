require "../spec_helper"

module Symmetry
  module Crystallographic
    describe IsometryKind do
      it "is a flags enum" do
        iso_kind = IsometryKind::Mirror | IsometryKind::Rotation2
        iso_kind.mirror?.should be_true
        iso_kind.rotation2?.should be_true
        iso_kind.identity?.should be_false
      end
    end
  end
end
