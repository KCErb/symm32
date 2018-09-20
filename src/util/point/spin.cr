module SymmUtil
  # A two-state point where `invert_state` reverses
  # internal state.
  # Uses enum `Handedness` for internal state.
  struct Spin < Point
    # The so-called `internal-state` of this point.
    getter handedness : Handedness

    def initialize(@coordinates, right = true)
      @handedness = right ? Handedness::Right : Handedness::Left
    end

    def invert_state
      @handedness = @handedness.flip
    end

    # Determines equality based on `coordinates` and `handedness`.
    def ==(other : Spin)
      @coordinates.round(Float64::DIGITS) == other.coordinates.round(Float64::DIGITS) &&
        @handedness == other.handedness
    end

    # :nodoc:
    def hash(hasher)
      hasher = @coordinates.round(Float64::DIGITS).hash(hasher)
      hasher = @handedness.hash(hasher)
      hasher
    end

    def_clone
  end

  # Simple enum for tracking internal state of `Spin`.
  enum Handedness
    Right
    Left

    # Swap value of this enum. Left becomes Right
    # and Right becomes Left.
    def flip
      right? ? Left : Right
    end
  end
end
