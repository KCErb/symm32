module Symm32
  # See `Isometry`, isometries including this module
  # get their `#transform` method from here.
  module CompoundIsometry
    getter isometries : Set(Isometry)

    # Operate on the point with each isometry's transform method
    # in order, returning the resultant point.
    def transform(point : Point)
      isometries.reduce(point) { |acc, isometry| isometry.transform(acc) }
    end
  end
end
