module Symmetry
  # invert everything about the origin
  # https://en.wikipedia.org/wiki/Point_reflection#Inversion_with_respect_to_the_origin
  class Inversion < PointIsometry
    def transform(point : Vector3)
      -point
    end
  end

  PointIsometry::INVERSION = Inversion.new
end
