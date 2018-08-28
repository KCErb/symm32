require "../spec_helper"

module SymmUtil
  struct TestPoint < Point
    getter internal_state : Int32
    def_clone

    def initialize(@coordinates, default = true)
      @internal_state = default ? 1 : 0
    end

    def ==(other : TestPoint)
      coordinates.round(Float64::DIGITS) == other.coordinates.round(Float64::DIGITS) &&
        @internal_state == other.internal_state
    end

    def invert_state
      @internal_state = @internal_state == 1 ? 0 : 1
    end
  end
end
