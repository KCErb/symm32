require "../../spec_helper"

module Symmetry
  class TestPointIsometry < PointIsometry
    def transform(point : Vector3)
      point * 3
    end
  end

  class TestCompoundPointIsometry < PointIsometry
    include CompoundIsometry

    def initialize
      @isometries = [] of Isometry
      @isometries << TestIsometry.new
      @isometries << TestIsometry.new
    end
  end

  class TestPointGroup < PointGroup
  end
end
