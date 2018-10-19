module Symm32
  # The [mirror](https://en.wikipedia.org/wiki/Reflection_(mathematics) operation.
  #
  # A mirror plane is specified by the axis normal to the plane.
  #
  # ```
  # mirror_z = Symm32::Mirror.new(Axis::Z)
  # ```

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

    # Creates new instance of the `Mirror` isometry.
    #
    # The `axis` here is a point normal to the plane you want
    # to mirror through.
    #
    # ```
    # mirror = Mirror.new(Axis::Z)
    # ```
    #
    # To obtain *the* singleton instance, use (for example)
    # `PointIsometry#parse("mz")` which caches Isometry creation for this
    # very purpose. (Think `Set`s.)
    def initialize(@axis : Axis)
      @kind = :mirror
      x, y, z = @axis.values
      @a_11 = 1 - 2*x**2
      @a_22 = 1 - 2*y**2
      @a_33 = 1 - 2*z**2
      @a_12 = -2*x*y
      @a_13 = -2*x*z
      @a_23 = -2*y*z
    end

    # Reflect the point through the mirror plane.
    #
    # Also flips chirality of the point itself if it is chiral.
    # (See `ChiralPoint`)
    def transform(point : Point)
      tuple = {
        point.x * @a_11 + point.y * @a_12 + point.z * @a_13,
        point.x * @a_12 + point.y * @a_22 + point.z * @a_23,
        point.x * @a_13 + point.y * @a_23 + point.z * @a_33,
      }
      new_coords = Vector3.new(*tuple)
      p_new = point.clone
      p_new.coordinates = new_coords
      p_new.invert(:chirality)
      p_new
    end
  end
end
