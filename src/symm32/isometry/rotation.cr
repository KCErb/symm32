module Symm32
  class Rotation
    include Isometry
    getter angle : Float64
    getter axis

    # pre-computed matrix elements
    alias Row = {Float64, Float64, Float64}
    @matrix : {Row, Row, Row}

    def initialize(@axis : Axis, n_fold : Int32, power = 1)
      kind_enum = "Rotation#{n_fold}"
      kind_enum += "_#{power}" unless power == 1
      @kind = IsometryKind.parse(kind_enum)
      @angle = 2 * Math::PI / n_fold * power
      @matrix = compute_matrix
    end

    def transform(point : Vector3)
      tuple = {
        point.x * @matrix[0][0] + point.y * @matrix[0][1] + point.z * @matrix[0][2],
        point.x * @matrix[1][0] + point.y * @matrix[1][1] + point.z * @matrix[1][2],
        point.x * @matrix[2][0] + point.y * @matrix[2][1] + point.z * @matrix[2][2],
      }
      Vector3.new(*tuple)
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
  end
end
