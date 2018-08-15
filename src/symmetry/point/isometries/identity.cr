module Symmetry
  # The do-nothing operation
  class Identity < PointIsometry
    def transform(point)
      point
    end
  end

  # We'll only ever need one instance of this PointIsometry
  PointIsometry::IDENTITY = Identity.new
end
