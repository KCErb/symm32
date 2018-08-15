require "./isometry"

module Symmetry
  module CompoundIsometry
    def transform(point : Vector3)
      @isometries.reduce(point) { |acc, isometry| isometry.transform(acc) }
    end
  end
end
