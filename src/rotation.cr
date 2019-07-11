module Symm32
  # The [rotation operation](https://en.wikipedia.org/wiki/Rotation_(mathematics%29).
  class Rotation
    include SymmBase::Isometry
    getter angle : Float64
    getter axis : Axis

    # Rotate about an axis by an angle.
    #
    # The angle is specified by the integer `n_fold` and the integer `power`.
    # `n_fold` simply means that we divide the full circle n-times. So
    # an n_fold rotation is just a 2pi/n radians rotation. `power` corresponds
    # to the number of times we take the rotation. So for example
    # taking a 4 fold rotation (90 degrees) once is 90 degrees, twice
    # is 180 degrees and so on. Ex:
    #
    # ```
    # rot = Rotation.new(Axis::Z, 3, 2)
    # ```
    #
    # To obtain *the* singleton instance of this class, use (for example)
    # `PointIsometry#parse("3z^2")` which caches Isometry creation for this
    # very purpose. (Think `Set`s.)
    def initialize(@axis, n_fold : Int32, power = 1)
      @kind = init_kind(n_fold, power)
      @angle = 2 * Math::PI / n_fold * power
      @matrix = SymmBase::RotationMatrix.new(axis.coordinates, angle)
    end

    # Transforms the coordinates of point by rotating them
    # around `axis` by `angle`.
    def transform(point : SymmBase::Point)
      p_new = point.clone
      p_new.coordinates = @matrix * point.coordinates
      p_new
    end

    # Transform a [SymmBase::Vectorlike](https://crystal-symmetry.gitlab.io/symm_base/SymmBase/Vectorlike.html) object by rotating it around `axis` by `angle`.
    def transform(vectorlike : SymmBase::Vectorlike)
      @matrix * vectorlike
    end

    private def init_kind(n_fold, power)
      case n_fold
      when 2
        :rotation_2
      when 3
        case power
        when 1
          :rotation_3
        when 2
          :rotation_3_2
        else
          raise "Invalid power for 3-fold rotation: #{power}. Only 1 and 2 allowed."
        end
      when 4
        case power
        when 1
          :rotation_4
        when 2
          :rotation_2
        when 3
          :rotation_4_3
        else
          raise "Invalid power for 4-fold rotation: #{power}. Only 1-3 allowed."
        end
      when 6
        case power
        when 1
          :rotation_6
        when 2
          :rotation_3
        when 3
          :rotation_2
        when 4
          :rotation_3_2
        when 5
          :rotation_6_5
        else
          raise "Invalid power for 6-fold rotation: #{power}. Only 1-5 are allowed."
        end
      else
        raise "Invalid `n_fold` rotation: #{n_fold}, must be 2, 3, 4, or 6."
      end
    end
  end
end
