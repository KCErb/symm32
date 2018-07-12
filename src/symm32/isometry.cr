module Symm32
  class Isometry

    getter bar : Bool
    getter kind : IsometryKind
    getter direction : Directions::Direction | Nil
    getter power : UInt8

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
    def initialize(pull : JSON::PullParser)
      nameString = pull.read_string
      @bar = nameString[0] == '-'
      nameString = nameString.lchop if @bar

      @kind = init_kind(nameString)

      # parse direction and power
      name_parts = nameString.partition("^")
      @direction = init_direction(name_parts[0])
      @power = name_parts[2].to_u8? || 1_u8
    end

    def plane_angle
      return nil unless direction && direction.orientation.is_a?(Directions::Plane)
      direction.orientation.angle
    end

    # calculate angle between self and other isometry
    def angle_from(other)
      return nil unless direction && other.direction
      theta_1, phi_1 = other.spherical_coords
      theta_2, phi_2 = spherical_coords
      phi_diff = (phi_2-phi_1)/2
      lambda_diff = (theta_2-theta_1)/2
      2*Math.asin(
        Math.sqrt(
          Math.sin(phi_diff)**2 +
          Math.cos(phi_1) * Math.cos(phi_2) * Math.sin(lambda_diff)**2
        )
      )
    end

    def spherical_coords
      return nil unless direction
      direction.orientation.spherical
    end

    private def init_kind(nameString)
      kind_string = nameString[0].to_s
      kind_string = "-" + kind_string if @bar
      case kind_string
      when "e"
        IsometryKind::Identity
      when "i"
        IsometryKind::Inversion
      when "m"
        IsometryKind::Mirror
      when /^-?\d+/
        init_rotation_kind(kind_string)
      else
        raise "Unable to create Isometry for #{nameString}: not able to determine kind."
      end
    end

    # 2, 3, 4, 6 or -2, -3, -4, -6
    private def init_rotation_kind(kind_string)
      improper = kind_string[0] == '-' ? "Improper" : nil
      n_fold = kind_string[-1]
      IsometryKind.parse("#{improper}Rotation#{n_fold}")
    end

    # dir is special string like mt30, 3d4, mz, or just i
    private def init_direction(direction)
      direction = direction.lchop # remove kind (m, 3, e, i)
      return nil if direction == "" # e and i have no direction

      dir_char = direction[0]
      # z has only one instance
      return Directions::Axial.instance if dir_char == 'z'

      arg = direction.lchop.to_u8
      case dir_char
      when 't'
        Directions::Plane.instance(arg)
      when 'd'
        Directions::Diagonal.instance(arg)
      when 'e'
        Directions::Edge.instance(arg)
      else
        raise "Invalid direction for isometry: `#{direction}`"
      end
    end
  end
end
