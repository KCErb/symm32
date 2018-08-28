module SymmUtil
  struct Charge < Point
    getter sign : Sign

    def initialize(@coordinates, plus = true)
      @sign = plus ? Sign::Plus : Sign::Minus
    end

    def ==(other : Charge)
      @coordinates.round(Float64::DIGITS) == other.coordinates.round(Float64::DIGITS) &&
        @sign == other.sign
    end

    def hash(hasher)
      hasher = @coordinates.round(Float64::DIGITS).hash(hasher)
      hasher = @sign.hash(hasher)
      hasher
    end

    def_clone
  end

  enum Sign
    Plus
    Minus
  end
end
