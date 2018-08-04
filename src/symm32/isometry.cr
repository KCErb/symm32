module Symm32
  struct Isometry
    getter kind : IsometryKind
    getter axis : Axis

    # Name format of isometry example (-3d2^2):
    # -3d2^2
    # ^^^^^^
    # 1233^4
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
      kind, _, power = nameString.partition("^")
      bar = kind[0] == '-'
      @axis = init_axis(kind, bar)
      power = power.to_u8? || 1_u8
      @kind = init_kind(kind, power, bar)
    end

    def initialize(@kind, @axis); end

    # calculate angle between self and other isometry
    def angle_from(other)
      return nil unless direction && other.direction
      theta_1, phi_1 = other.spherical_coords
      theta_2, phi_2 = spherical_coords
      phi_diff = (phi_2 - phi_1)/2
      lambda_diff = (theta_2 - theta_1)/2
      2*Math.asin(
        Math.sqrt(
          Math.sin(phi_diff)**2 +
          Math.cos(phi_1) * Math.cos(phi_2) * Math.sin(lambda_diff)**2
        )
      )
    end

    def spherical_coords
      return nil unless direction
      direction.axis.spherical
    end

    private def init_kind(kind, power, bar)
      kind_string = kind[0] == '-' ? kind[0, 2] : kind[0, 1]
      case kind_string
      when "e"
        IsometryKind::Identity
      when "i"
        IsometryKind::Inversion
      when "m"
        IsometryKind::Mirror
      when /^-?\d+/
        init_rotation_kind(kind_string, power, bar)
      else
        raise "Unable to create Isometry for #{kind}: not able to determine kind."
      end
    end

    # 2, 3, 4, 6 or -2, -3, -4, -6
    private def init_rotation_kind(kind_string, power, bar)
      improper = bar ? "Improper" : nil
      n_fold = kind_string[-1]
      kind_enum = "#{improper}Rotation#{n_fold}"
      kind_enum += "_#{power}" if power != 1_u8
      IsometryKind.parse(kind_enum)
    end

    private def init_axis(direction, bar)
      # remove kind => mt30 => t30, -4z => z
      direction = bar ? direction[2..-1] : direction[1..-1]
      return Axis::None if direction == "" # e and i have no axis

      dir_char = direction[0]
      return Axis::Z if dir_char == 'z'

      arg = direction.lchop.to_u8
      Axis.parse("#{dir_char}#{arg}")
    end
  end
end
