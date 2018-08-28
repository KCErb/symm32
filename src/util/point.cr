module SymmUtil
  abstract struct Point
    property coordinates : Vector3

    # A point needs coordinates and flag whether to use the default
    # internal state or its opposite (assumed two state points)
    def initialize(@coordinates, default = true); end

    delegate x, y, z, to: @coordinates

    # How should this Point respond to an inversion operation?
    # By default, it does nothing. Points track their own internal state
    def invert_state; end

    abstract def clone
    abstract def ==(other : Point)
  end
end
