require "../spec_helper"

module Symm32
  ISO0 = Isometry::IDENTITY
  ISO1 = Mirror.new(Axis::Z)
  ISO2 = Mirror.new(Axis::T90)
  ISO3 = Rotation.new(Axis::T0, 2)
  ISO4 = Rotation.new(Axis::Z, 2)
  ISO5 = Rotation.new(Axis::D1, 3)

  ISOMETRIES1 = Set{ISO0, ISO1, ISO2, ISO3, ISO4}
  ISOMETRIES2 = Set{ISO0, ISO1, ISO3}
  ISOMETRIES3 = Set{ISO0, ISO2, ISO4}

  class TestIsometry
    include Isometry

    def initialize(@increment = 0)
      @kind = IsometryKind::None
    end

    def transform(point : Point)
      new_coord = point.coordinates
      new_coord.z += @increment
      p_new = point.clone
      p_new.coordinates = new_coord
      p_new
    end
  end

  class TestCompoundIsometry
    include Isometry
    include CompoundIsometry

    def initialize
      @kind = IsometryKind::None
      @isometries = Set(Isometry).new
      @isometries << TestIsometry.new(2)
      @isometries << TestIsometry.new(3)
    end
  end
end
