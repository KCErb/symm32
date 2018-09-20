module SymmUtil
  # Wraps `Vector3` so that the point represented by that vector can have
  # some kind of internal state. This is especially important for
  # `Symm32::Inversion` and `Symm32::Mirror` isometries which call
  # `Point#invert_state` to let points know that inversion operations
  # have taken place.
  abstract struct Point
    # The `Vector3` for this Point.
    property coordinates : Vector3

    # A point needs coordinates and may choose whether to use the default
    # internal state or its opposite (assumed two state points)
    def initialize(@coordinates, default = true); end

    # Returns the result of calling this method on `#coordinates`.
    delegate x, y, z, values, to: @coordinates

    # How should this Point respond to an inversion operation?
    # By default, it does nothing. Points track their own internal state
    def invert_state; end

    abstract def clone
    abstract def ==(other : Point)
  end
end
