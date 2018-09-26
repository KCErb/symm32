module Symm32
  # A Point which tracks `chirality` as its internal state.
  #
  # Default is `Chirality::Right` representing a right-handed version of this
  # point. A call to `#invert(:chirality)` will flip the chirality to
  # `Chirality::Left`.
  #
  # The purpose of this point is to pair with the `Mirror` and `Inversion`
  # isometries which invert the chirality of the objects they act on.
  struct ChiralPoint < Point
    # The so-called `internal-state` of this point.
    getter chirality : Chirality

    def initialize(@coordinates)
      @chirality = Chirality::Right
    end

    def invert(symbol)
      if (symbol == :chirality)
        @chirality = @chirality.flip
      end
    end

    # Determines equality based on `coordinates` and `chirality`.
    def ==(other : ChiralPoint)
      @coordinates.round(Float64::DIGITS) == other.coordinates.round(Float64::DIGITS) &&
        @chirality == other.chirality
    end

    # :nodoc:
    def hash(hasher)
      hasher = @coordinates.round(Float64::DIGITS).hash(hasher)
      hasher = @chirality.hash(hasher)
      hasher
    end

    def_clone
  end

  # Simple enum for tracking internal state of `ChiralPoint`.
  enum Chirality
    Right
    Left

    # Swap value of this enum. Left becomes Right
    # and Right becomes Left.
    def flip
      right? ? Left : Right
    end
  end
end
