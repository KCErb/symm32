module SymmUtil
  # A two-state point where `invert_state` has no impact on internal state.
  # Uses enum `Sign` for internal state.
  struct Charge < Point
    # The so-called `internal-state` of this point.
    getter sign : Sign

    def initialize(@coordinates, plus = true)
      @sign = plus ? Sign::Plus : Sign::Minus
    end

    # Determines equality based on `coordinates` and `sign`.
    def ==(other : Charge)
      @coordinates.round(Float64::DIGITS) == other.coordinates.round(Float64::DIGITS) &&
        @sign == other.sign
    end

    # :nodoc:
    def hash(hasher)
      hasher = @coordinates.round(Float64::DIGITS).hash(hasher)
      hasher = @sign.hash(hasher)
      hasher
    end

    def_clone
  end

  # Simple enum for tracking internal state of `Charge`.
  enum Sign
    Plus
    Minus
  end
end
