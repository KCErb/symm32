module Symm32
  module CompoundIsometry
    getter isometries : Set(Isometry)

    def transform(point : Point)
      isometries.reduce(point) { |acc, isometry| isometry.transform(acc) }
    end
  end
end
