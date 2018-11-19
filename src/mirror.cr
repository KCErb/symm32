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
      @matrix = ReflectionMatrix.new(axis.coordinates)
    end

    # Reflect the point through the mirror plane.
    #
    # Also flips chirality of the point itself if it is chiral.
    # (See `ChiralPoint`)
    def transform(point : Point)
      p_new = point.clone
      p_new.coordinates = @matrix * point.coordinates
      p_new.invert(:chirality)
      p_new
    end
  end
end
