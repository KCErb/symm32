module Symm32
  module CompoundIsometry
    getter isometries : Array(Isometry)

    def transform(point : Vector3)
      isometries.reduce(point) { |acc, isometry| isometry.transform(acc) }
    end
  end
end
