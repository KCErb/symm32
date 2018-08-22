module Symm32
  class Mirror
    include Isometry
    getter axis

    # pre-computed matrix elements
    @a_11 : Float64
    @a_22 : Float64
    @a_33 : Float64
    @a_12 : Float64
    @a_13 : Float64
    @a_23 : Float64

    def initialize(@axis : Axis)
      @kind = IsometryKind::Mirror
      x, y, z = @axis.values
      @a_11 = 1 - 2*x**2
      @a_22 = 1 - 2*y**2
      @a_33 = 1 - 2*z**2
      @a_12 = -2*x*y
      @a_13 = -2*x*z
      @a_23 = -2*y*z
    end

    def transform(point : Vector3)
      tuple = {
        point.x * @a_11 + point.y * @a_12 + point.z * @a_13,
        point.x * @a_12 + point.y * @a_22 + point.z * @a_23,
        point.x * @a_13 + point.y * @a_23 + point.z * @a_33,
      }
      Vector3.new(*tuple)
    end
  end
end
