module Symmetry
  module Crystallographic
    class Inversion < Symmetry::Inversion
      include PointIsometry

      def initialize
        @isometry_kind = IsometryKind::Inversion
      end
    end

    PointIsometry::INVERSION = Inversion.new
  end
end
