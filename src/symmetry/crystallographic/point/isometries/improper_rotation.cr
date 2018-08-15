module Symmetry
  module Crystallographic
    class ImproperRotation < Symmetry::ImproperRotation
      include PointIsometry

      def initialize(@enum_axis : Axis, n_fold : Int32, power = 1)
        kind_enum = "ImproperRotation#{n_fold}"
        kind_enum += "_#{power}" unless power == 1
        @isometry_kind = IsometryKind.parse(kind_enum)
        super(@enum_axis.delegate, n_fold, power)
      end

      # using enum object pattern, see README
      def axis
        @enum_axis
      end
    end
  end
end
