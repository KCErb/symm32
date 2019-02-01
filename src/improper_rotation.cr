module Symm32
  # The [improper rotation](https://en.wikipedia.org/wiki/Improper_rotation) operation.
  #
  # Rotate a point about an axis and invert. This is
  # a `CompoundIsometry` so its transform method
  # is a combination of `Rotation` and `Inversion`.
  class ImproperRotation
    include SymmBase::CompoundIsometry
    getter axis

    # Creates new instance of the ImproperRotation isometry.
    #
    # The rotation angle is specified as a combination of n_fold and power
    # such that a 3-fold rotation, twice (240 degrees), along the z-axis
    # would be created like so:
    #
    # ```
    # ir = ImproperRotation.new(Axis::Z, 3, 2)
    # ```
    #
    # To obtain *the* singleton instance of this class, use (for example)
    # `PointIsometry#parse("-3z^2")` which caches Isometry creation for this
    # very purpose. (Think `Set`s.)
    def initialize(@axis : Axis, n_fold : Int32, power = 1)
      @kind = init_kind(n_fold, power)
      @isometries = Set(SymmBase::Isometry).new
      @isometries << Rotation.new(@axis, n_fold, power)
      @isometries << PointIsometry.parse("i")
    end

    # Specifies allowed n_fold rotations and returns unique symbol for each
    # one. Raises an error if the combination of n_fold and power
    # doesn't result in a crystallographically allowed rotation angle.
    private def init_kind(n_fold, power)
      case n_fold
      when 2
        :improper_rotation_2
      when 3
        case power
        when 1
          :improper_rotation_3
        when 2
          :improper_rotation_3_2
        else
          raise "Invalid power for 3-fold improper rotation: #{power}. Only 1 and 2 allowed."
        end
      when 4
        case power
        when 1
          :improper_rotation_4
        when 2
          :improper_rotation_2
        when 3
          :improper_rotation_4_3
        else
          raise "Invalid power for 4-fold improper rotation: #{power}. Only 1-3 allowed."
        end
      when 6
        case power
        when 1
          :improper_rotation_6
        when 2
          :improper_rotation_3
        when 3
          :improper_rotation_2
        when 4
          :improper_rotation_3_2
        when 5
          :improper_rotation_6_5
        else
          raise "Invalid power for 6-fold improper rotation: #{power}. Only 1-5 are allowed."
        end
      else
        raise "Invalid `n_fold` improper rotation: #{n_fold}, must be 2, 3, 4, or 6."
      end
    end
  end
end
