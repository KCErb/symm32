module SymmUtil
  struct Spin < Point
    getter handedness : Handedness

    def initialize(@coordinates, right = true)
      @handedness = right ? Handedness::Right : Handedness::Left
    end

    def invert_state
      @handedness = @handedness.flip
    end

    def ==(other : Spin)
      @coordinates.round(Float64::DIGITS) == other.coordinates.round(Float64::DIGITS) &&
        @handedness == other.handedness
    end

    def hash(hasher)
      hasher = @coordinates.round(Float64::DIGITS).hash(hasher)
      hasher = @handedness.hash(hasher)
      hasher
    end

    def_clone
  end

  enum Handedness
    Right
    Left

    def flip
      right? ? Left : Right
    end
  end
end
