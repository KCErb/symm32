module Symm32
  # The [identity](https://en.wikipedia.org/wiki/Identity_element) operation.
  class Identity
    include SymmBase::Isometry

    # Creates new instance of the Identity isometry. To obtain the singleton
    # instance of this class, use `PointIsometry#parse("e")` which
    # caches Isometry creation for this purpose.
    def initialize
      @kind = :identity
    end

    # Returns `point` unchanged
    def transform(point)
      point
    end
  end
end
