require "spec"
require "../src/symm32"

module Symm32
  ISO0 = PointIsometry.parse("e")
  ISO1 = Mirror.new(Axis::Z)
  ISO2 = Mirror.new(Axis::T90)
  ISO3 = Rotation.new(Axis::T0, 2)
  ISO4 = Rotation.new(Axis::Z, 2)
  ISO5 = Rotation.new(Axis::D1, 3)

  ISOMETRIES1 = Set{ISO0, ISO1, ISO2, ISO3, ISO4}
  ISOMETRIES2 = Set{ISO0, ISO1, ISO3}
  ISOMETRIES3 = Set{ISO0, ISO2, ISO4}
end
