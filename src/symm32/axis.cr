module Symm32
  enum Axis : UInt8
    None # identity and inverse have a location not an axis
    Z    # z-axis {0,0,1}
    T0   # x-axis {1,0,0}
    T30
    T45
    T60
    T90 # y-axis {0,1,0}
    T120
    T135
    T150
    # edges are counted clockwise from x-direction as you look down the z-axis on a cube
    E1 # {1,0,1}
    E2 # {0,1,1}
    E3 # {-1,0,1}
    E4 # {0,-1,1}
    # diagonals are counted similarly, clockwise starting from x direction looking down z
    D1 # {1,1,1}
    D2 # {-1,1,1}
    D3 # {-1,-1,1}
    D4 # {1,-1,1}

    def planar?
      plane.includes?(self)
    end

    def edge?
      {E1, E2, E3, E4}.includes?(self)
    end

    def diagonal?
      {D1, D2, D3, D4}.includes?(self)
    end

    # Get back the integers to the right of type, T90 => 90, E4 => 4
    # raise error if not available (Z, None)
    def arg_int
      num = to_s.lchop
      res = num.to_u8?
      raise "Can't call arg_int on `#{to_s}`" unless res
      res
    end

    def angle
      raise "No angle for: `#{to_s}`" unless planar?
      arg_int * Math::PI / 180
    end

    def angle_from(other : Axis)
      dot = cartesian.dot other.cartesian
      maga = cartesian.magnitude
      magb = other.cartesian.magnitude
      cth = dot / maga / magb
      Math.acos(cth)
    end

    # Cartesian representation of this axis
    def cartesian
      tuple = case
      when none?
        {0.0, 0.0, 0.0}
      when z?
        {0.0, 0.0, 1.0}
      when planar?
        {Math.cos(angle), Math.sin(angle), 0.0}
      when edge?
        case arg_int
        when 1
          {1.0, 0.0, 1.0}
        when 2
          {0.0, 1.0, 1.0}
        when 3
          {-1.0, 0.0, 1.0}
        when 4
          {0.0, -1.0, 1.0}
        else
          raise "Invalid Edge Number: `#{arg_int}`"
        end
      when diagonal?
        case arg_int
        when 1
          {1.0, 1.0, 1.0}
        when 2
          {-1.0, 1.0, 1.0}
        when 3
          {-1.0, -1.0, 1.0}
        when 4
          {1.0, -1.0, 1.0}
        else
          raise "Invalid Diagonal Number: `#{arg_int}`"
        end
      else
        raise "Invalid Axis: `#{to_s}`"
      end
      Vector3.new(*tuple)
    end

    # spherical coordinates {r, theta, phi} (distance, polar, azimuthal)
    # for this axis
    def spherical
      tuple = if (cartesian.zero?)
        cartesian.values
      elsif (planar?)
        {1.0, Math::PI / 2.0, angle}
      else
        polar, azimuthal = compute_angles
        {1.0, polar, azimuthal}
      end
      Vector3.new(*tuple)
    end

    # array of axes orthogonal to this one
    # the **order is very important**, it is used to infer the different planar
    # orientations by assuming that they are in clockwise order with respect
    # to the axis and some starting point.
    def orthogonal
      case
      when none?
        [] of Axis
      when z?
        plane
      when planar?
        case arg_int
        when 0
          o = [T90, E2, Z, E4]
        when 30
          o = [T120, Z]
        when 45
          o = [T135, D2, Z, D4]
        when 60
          o = [T150, Z]
        when 90
          o = [E3, Z, E1, T0]
        when 120
          o = [Z, T30]
        when 135
          o = [D3, Z, D1, T45]
        when 150
          o = [Z, T60]
        else
          raise "Invalid Plane Angle: `#{arg_int}`"
        end
      when edge?
        case arg_int
        when 1
          [T90, D2, E3, D3]
        when 2
          [D3, E4, D4, T0]
        when 3
          [D4, E1, D1, T90]
        when 4
          [T0, D1, E2, D2]
        else
          raise "Invalid Diagonal Number: `#{arg_int}`"
        end
      when diagonal?
        case arg_int
        when 1
          [T135, E3, E4]
        when 2
          [E4, E1, T45]
        when 3
          [E1, E2, T135]
        when 4
          [T45, E2, E3]
        else
          raise "Invalid Edge Number: `#{arg_int}`"
        end
      else
        raise "Invalid Axis: `#{to_s}`"
      end
    end

    private def compute_angles
      x, y, z = cartesian.values
      r = Math.sqrt(x**2 + y**2 + z**2)
      polar = Math.acos(z/r)
      azimuthal = Math.atan2(y, x)
      {polar, azimuthal}
    end

    private def plane
      [T0, T30, T45, T60, T90, T120, T135, T150]
    end
  end
end
