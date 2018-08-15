module Symmetry
  module Crystallographic
    class Mirror < Symmetry::Mirror
      include PointIsometry

      def initialize(@enum_axis : Axis)
        super(@enum_axis.delegate)
        @isometry_kind = IsometryKind::Mirror
      end

      # using enum object pattern, see README
      def axis
        @enum_axis
      end
    end
  end
end
