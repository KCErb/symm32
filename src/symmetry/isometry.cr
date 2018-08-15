module Symmetry
  abstract class Isometry
    abstract def transform(point : Vector3)
  end
end
