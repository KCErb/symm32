module Symm32
  # The [mirror](https://en.wikipedia.org/wiki/Reflection_(mathematics) operation.
  #
  # A mirror plane is specified by an axis normal to its plane.
  #
  # ```
  # mirror_z = Symm32::Mirror.new(Axis::Z)
  # ```
  class Mirror
    include SymmBase::Isometry
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
      @matrix = SymmBase::ReflectionMatrix.new(axis.coordinates)
    end

    # Reflect the point through the mirror plane.
    #
    # Also flips chirality of the point itself if it is chiral.
    # (See `ChiralPoint`)
    def transform(point : SymmBase::Point)
      p_new = point.clone
      p_new.coordinates = @matrix * point.coordinates
      p_new.invert(:chirality)
      p_new
    end

    # Reflect a [Vectorlike](https://crystal-symmetry.gitlab.io/symm_base/SymmBase/Vectorlike.html) object through the plane of the mirror.
    #
    # The `invert` argument allows the vectorlike to be "chiral" in that we give the additive inverse under reflection when `:chiral` is passed into this array.
    def transform(vectorlike : SymmBase::Vectorlike, invert = [] of Symbol)
      new_vec = @matrix * vectorlike
      if invert.includes? :chiral
        new_vec = {-new_vec[0], -new_vec[1], -new_vec[2]}
      end
      new_vec
    end
  end
end
