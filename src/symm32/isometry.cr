module Symm32
  module Isometry
    getter kind : IsometryKind

    # create isometry from minimal string
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
    def self.parse(nameString)
      kind, _, power = nameString.partition("^")
      return IDENTITY if kind == "e"
      return INVERSION if kind == "i"
      bar = kind[0] == '-'
      axis = parse_axis(kind, bar)
      return Mirror.new(axis) if kind[0] == 'm'
      init_rotation(bar, axis, kind, power)
    end

    private def self.parse_axis(direction, bar)
      # remove kind => mt30 => t30, -4z => z
      direction = bar ? direction[2..-1] : direction[1..-1]
      return Axis::Origin if direction == "" # e and i have no axis

      dir_char = direction[0]
      return Axis::Z if dir_char == 'z'

      arg = direction.lchop.to_u8
      Axis.parse("#{dir_char}#{arg}")
    end

    private def self.init_rotation(bar, axis, kind, power)
      # 2, 3, 4, 6 or -2, -3, -4, -6 from stuff like mz or 3d2
      kind_string = bar ? kind[0, 2] : kind[0, 1]
      n_fold = kind_string[-1].to_s
      power = 1 if power.empty?
      if bar
        ImproperRotation.new(axis, n_fold.to_i32, power.to_i32)
      else
        Rotation.new(axis, n_fold.to_i32, power.to_i32)
      end
    end
  end
end
