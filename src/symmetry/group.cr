module Symmetry
  abstract class Group
    getter isometries : Array(Isometry)

    def initialize(@isometries); end
  end
end
