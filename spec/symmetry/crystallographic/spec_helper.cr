require "../../spec_helper"

module Symmetry
  module Crystallographic
    ISO0 = PointIsometry::IDENTITY
    ISO1 = Mirror.new(Axis::Z)
    ISO2 = Mirror.new(Axis::T90)
    ISO3 = Rotation.new(Axis::T0, 2)
    ISO4 = Rotation.new(Axis::Z, 2)
    ISO5 = Rotation.new(Axis::D1, 3)

    ISOMETRIES1 = [ISO0, ISO1, ISO2, ISO3, ISO4] of PointIsometry
    ISOMETRIES2 = [ISO0, ISO1, ISO3] of PointIsometry
    ISOMETRIES3 = [ISO0, ISO2, ISO4] of PointIsometry
  end
end
