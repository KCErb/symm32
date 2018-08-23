require "../spec_helper"

module Symm32
  ISO0 = Isometry::IDENTITY
  ISO1 = Mirror.new(Axis::Z)
  ISO2 = Mirror.new(Axis::T90)
  ISO3 = Rotation.new(Axis::T0, 2)
  ISO4 = Rotation.new(Axis::Z, 2)
  ISO5 = Rotation.new(Axis::D1, 3)

  ISOMETRIES1 = [ISO0, ISO1, ISO2, ISO3, ISO4] of Isometry
  ISOMETRIES2 = [ISO0, ISO1, ISO3] of Isometry
  ISOMETRIES3 = [ISO0, ISO2, ISO4] of Isometry

  class TestIsometry
    include Isometry

    def initialize
      @kind = IsometryKind::None
    end

    def transform(point : Vector3)
      point.z += 3
      point
    end
  end

  class TestCompoundIsometry
    include Isometry
    include CompoundIsometry

    def initialize
      @kind = IsometryKind::None
      @isometries = [] of Isometry
      @isometries << TestIsometry.new
      @isometries << TestIsometry.new
    end
  end
end
