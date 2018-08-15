require "spec"
require "../src/symmetry"

module Symmetry
  class TestIsometry < Isometry
    def transform(point : Vector3)
      point.z += 3
      point
    end
  end

  class TestCompoundIsometry < Isometry
    include CompoundIsometry

    def initialize
      @isometries = [] of Isometry
      @isometries << TestIsometry.new
      @isometries << TestIsometry.new
    end
  end

  class TestGroup < Group
  end
end
