module Symm32
  # The [inversion operation](https://en.wikipedia.org/wiki/Point_reflection).
  class Inversion
    include Isometry

    def initialize
      @kind = IsometryKind::Inversion
    end

    # Invert a point about the origin.
    #
    # This method both inverts the coordinates of
    # the point (xyz => -x-y-z) and calls
    # `Point#invert_state` so that the point
    # can respond as needed to the inversion.
    def transform(point : Point)
      p_new = point.clone
      p_new.coordinates = -point.coordinates
      p_new.invert_state
      p_new
    end
  end

  Isometry::INVERSION = Inversion.new
end
