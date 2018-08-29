module Symm32
  class Rotation
    include Isometry
    getter angle : Float64
    getter axis : Axis

    # pre-computed matrix elements
    alias Row = {Float64, Float64, Float64}
    @matrix : {Row, Row, Row}

    def initialize(@axis, n_fold : Int32, power = 1)
      kind_enum = "Rotation#{n_fold}"
      kind_enum += "_#{power}" unless power == 1
      @kind = IsometryKind.parse(kind_enum)
      @angle = 2 * Math::PI / n_fold * power
      @matrix = compute_matrix
    end

    # it's convenient to just have a tool for rotation sometimes
    # so this doesn't strictly belong to Symm32 per se but
    # I tried abstracting this properly just to get this feature
    # and it's too much of a deviation from the intent of the library
    # yes this note is kinda long, that's because this kinda thing bugs me :)
    def initialize(@axis, @angle)
      @kind = IsometryKind::None
      @matrix = compute_matrix
    end

    def transform(vec : Vector3)
      compute_new_coords(*vec.values)
    end

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
