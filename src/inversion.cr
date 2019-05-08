module Symm32
  # The [inversion operation](https://en.wikipedia.org/wiki/Point_reflection).
  class Inversion
    include SymmBase::Isometry

    # Creates new instance of the Inversion isometry. To obtain the singleton
    # instance of this class, use `PointIsometry#parse("i")` which
    # caches Isometry creation for this purpose.
    def initialize
      @kind = :inversion
    end

    # Invert a point about the origin.
    #
    # This method both inverts the coordinates of
    # the point (xyz => -x-y-z) and the chirality
    # of the point itself if it is chiral. (See `ChiralPoint`)
    def transform(point : SymmBase::Point)
      p_new = point.clone
      p_new.coordinates = -point.coordinates
      p_new.invert(:chirality)
      p_new
    end

    def transform(vectorlike : SymmBase::Vectorlike)
      {-vectorlike[0], -vectorlike[1], -vectorlike[2]}
    end
  end
end
