module Symm32
  class Isometry

    getter bar : Bool
    getter kind : IsometryKind
    getter direction : String = ""
    getter power : Int8 = 1_i8

    # Name format of isometry example (-3d2^2):
    # -3d2^2
    # ^^^^^^
    # 123.4.
    # 1 - minus sign indicates invert after performing operation (bar)
    # 2 - kind of isometry:
    #   e - identity,
    #   i - point-inversion
    #   m - mirror plane (direction is of the normal)
    #   # - #-fold rotation (direction is of the axis)
    #   -# - #-fold improper-rotation (direction is of the axis)
    # 3 - direction of the isometry
    #   z - unique axis
    #   t - transverse plane from unique axis: t0, t30, t45, t60, ... t150
    #   d - diagonal (ex: 111 to -1-1-1): d1, d2, d3, d4)
    #   e - edge (ex: from 101 to 10-1): e1, e2, e3, e4)
    # 4 - if ^ is present, number of times to apply rotation

    # TODO: more error checking on name string since it determines object and is
    # quite rigidly specified
    def initialize(name)
      @bar = name[0] == '-'
      name = name.lchop if @bar

      @kind = init_kind(name)
      name = name.lchop

      return if (identity? || inverse?)

      if (name.size == 1)
        @direction = name
        return
      end

      # parse direction and power
      name_parts = name.partition("^")
      @direction = name_parts[0].to_s
      @power = name_parts[2].to_i8? || 1_i8
    end

    def identity?
      @kind.identity?
    end

    def inverse?
      @kind.inversion?
    end

    def rotation?
      @kind.rotation?
    end

    def reflection?
      @kind.mirror?
    end

    def axis?
      @direction == "z"
    end

    def plane?
      return false if @direction.empty?
      @direction[0] == 't'
    end

    def diagonal?
      return false if @direction.empty?
      @direction[0] == 'd'
    end

    def edge?
      return false if @direction.empty?
      @direction[0] == 'e'
    end

    def plane_angle
      return 0 unless plane?
      @direction.lchop.to_i
    end

    # direction: A direction string t30, d4, 2z, etc
    # determine if this isometry is in the plane normal
    # to that direction
    def in_plane?(direction : String)
      return false if direction.empty?
      direction_char = direction[0]
      case
      when direction_char == 'z'
        plane?
      when direction == "t0"
        axis? || @direction == "t90" || @direction == "e2" || @direction == "e4"
      when direction == "t45"
        axis? || @direction == "t135" || @direction == "d2" || @direction == "d4"
      when direction == "t90"
        axis? || @direction == "t0" || @direction == "e1" || @direction == "e3"
      when direction == "t135"
        axis? || @direction == "t45" || @direction == "d1" || @direction == "d3"
      when direction_char == 't'
        axis? || (plane_angle + 90) % 180 == direction.lchop.to_i
      when direction == "e1"
        @direction == "t90" || @direction == "d2" || @direction == "d3" || @direction == "e3"
      when direction == "e2"
        @direction == "t0" || @direction == "d3" || @direction == "d4" || @direction == "e4"
      when direction == "e3"
        @direction == "t90" || @direction == "d1" || @direction == "d4" || @direction == "e1"
      when direction == "e4"
        @direction == "t0" || @direction == "d1" || @direction == "d2" || @direction == "e2"
      when direction == "d1"
        @direction == "t135" || @direction == "e3" || @direction == "e4"
      when direction == "d2"
        @direction == "t45" || @direction == "e1" || @direction == "e4"
      when direction == "d3"
        @direction == "t135" || @direction == "e1" || @direction == "e2"
      when direction == "d4"
        @direction == "t45" || @direction == "e2" || @direction == "e3"
      end
    end

    # calculate angle between self and other isometry
    def angle_from(other)
      theta_1, phi_1 = other.orientation
      theta_2, phi_2 = orientation
      phi_diff = (phi_2-phi_1)/2
      lambda_diff = (theta_2-theta_1)/2
      2*Math.asin(
        Math.sqrt(
          Math.sin(phi_diff)**2 +
          Math.cos(phi_1) * Math.cos(phi_2) * Math.sin(lambda_diff)**2
        )
      )
    end

    # convert direction into absolute angle with polar theta (from z-axis)
    # and azimuth phi: [theta, phi]
    def orientation
      case
      when axis?
        [0.0, 0.0]
      when plane?
        rad = plane_angle * Math::PI / 180
        [Math::PI / 2, rad]
      when diagonal?
        diagonal_angle
      when edge?
        edge_angle
      else
        [0.0, 0.0]
      end
    end

    private def diagonal_angle
      case @direction
      when "d1"
        compute_angles([1,1,1])
      when "d2"
        compute_angles([-1,1,1])
      when "d3"
        compute_angles([-1,-1,1])
      when "d4"
        compute_angles([1,-1,1])
      else
        [0.0, 0.0]
      end
    end

    private def edge_angle
      case @direction
      when "e1"
        compute_angles([1,0,1])
      when "e2"
        compute_angles([0,1,1])
      when "e3"
        compute_angles([-1,0,1])
      when "e4"
        compute_angles([0,-1,1])
      else
        [0.0, 0.0]
      end
    end

    # given vector [x,y,z] return angles [theta, phi]
    # ex: [1,1,1] => [pi/4, pi/4]

    private def compute_angles(vector)
      x,y,z = vector
      r = Math.sqrt(x**2 + y**2 + z**2)
      theta = Math.acos(z/r)
      phi = Math.atan2(y, x)
      [theta, phi]
    end

    private def init_kind(name)
      kind_string = name[0].to_s
      kind_string = "-" + kind_string if @bar
      case kind_string
      when "e"
        IsometryKind::Identity
      when "i"
        IsometryKind::Inversion
      when "m"
        IsometryKind::Mirror
      when /^\d+/
        IsometryKind::Rotation
      when /^-\d+/
        IsometryKind::ImproperRotation
      else
        raise "Unable to create Isometry for #{name}: not able to determine kind."
      end
    end
  end
end
