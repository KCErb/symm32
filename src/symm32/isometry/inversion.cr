module Symm32
  class Inversion
    include Isometry

    def initialize
      @kind = IsometryKind::Inversion
    end

    def transform(point : Point)
      p_new = point.clone
      p_new.coordinates = -point.coordinates
      p_new.invert_state
      p_new
    end
  end

  Isometry::INVERSION = Inversion.new
end
