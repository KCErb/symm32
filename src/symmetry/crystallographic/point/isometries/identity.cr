module Symmetry
  module Crystallographic
    class Identity < Symmetry::Identity
      include PointIsometry

      def initialize
        @isometry_kind = IsometryKind::Identity
      end
    end

    PointIsometry::IDENTITY = Identity.new
  end
end
