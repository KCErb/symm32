module Symm32
  # The [rotation operation](https://en.wikipedia.org/wiki/Rotation_(mathematics%29)
  #
  class Rotation
    include Isometry
    getter angle : Float64
    getter axis : Axis

    # :nodoc:
    alias Row = {Float64, Float64, Float64}
    # pre-computed matrix elements
    @matrix : {Row, Row, Row}

    # Rotate about an axis by an angle.
    #
    # The angle is specified by the integer `n_fold` and the integer `power`.
    # `n_fold` simply means that we divide the full circle n-times. So
    # an n_fold rotation is just a 2pi/n radians rotation. `power` corresponds
    # to the number of times we take the rotation. So for example
    # taking a 4 fold rotation (90 degrees) once is 90 degrees, twice
    # is 180 degrees and so on.
    def initialize(@axis, n_fold : Int32, power = 1)
      kind_enum = "Rotation#{n_fold}"
      kind_enum += "_#{power}" unless power == 1
      @kind = IsometryKind.parse(kind_enum)
      @angle = 2 * Math::PI / n_fold * power
      @matrix = compute_matrix
    end

    # Rotate some arbitrary angle about an axis .
    #
    # It's convenient to just have a tool for rotation sometimes
    # so this doesn't strictly belong to Symm32 per se but
    # I tried abstracting this properly just to get this feature
    # and it's too much of a deviation from the intent of the library.
    # Yes this note is kinda long, that's because this kinda thing bugs me :)
    def initialize(@axis, @angle)
      @kind = IsometryKind::None
      @matrix = compute_matrix
    end

    # Transforms vec by rotating it around `axis` by `angle`.
    def transform(vec : Vector3)
      compute_new_coords(*vec.values)
    end

    # Transforms the coordinates of point by rotating them
    # around `axis` by `angle`.
    def transform(point : Point)
      new_coords = compute_new_coords(*point.values)
      p_new = point.clone
      p_new.coordinates = new_coords
      p_new
    end

    private def compute_matrix
      x, y, z = @axis.values
      cth = Math.cos(@angle)
      sth = Math.sin(@angle)
      om_cth = 1 - cth # one-minus cosine theta

      a_11 = x*x*om_cth + cth
      a_12 = x*y*om_cth - z*sth
      a_13 = x*z*om_cth + y*sth

      a_21 = x*y*om_cth + z*sth
      a_22 = y*y*om_cth + cth
      a_23 = y*z*om_cth - x*sth

      a_31 = x*z*om_cth - y*sth
      a_32 = y*z*om_cth + x*sth
      a_33 = z*z*om_cth + cth
      @matrix = { {a_11, a_12, a_13}, {a_21, a_22, a_23}, {a_31, a_32, a_33} }
    end

    private def compute_new_coords(x, y, z)
      tuple = {
        x * @matrix[0][0] + y * @matrix[0][1] + z * @matrix[0][2],
        x * @matrix[1][0] + y * @matrix[1][1] + z * @matrix[1][2],
        x * @matrix[2][0] + y * @matrix[2][1] + z * @matrix[2][2],
      }
      Vector3.new(*tuple)
    end
  end
end
