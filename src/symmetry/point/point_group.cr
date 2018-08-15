module Symmetry
  abstract class PointGroup
    getter isometries : Array(PointIsometry)

    def initialize(@isometries); end
  end
end
