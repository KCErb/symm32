module Symm32
  # The [identity](https://en.wikipedia.org/wiki/Identity_element) operation.
  class Identity
    include Isometry

    def initialize
      @kind = IsometryKind::Identity
    end

    # Returns `point` unchanged
    def transform(point)
      point
    end
  end

  Isometry::IDENTITY = Identity.new
end
