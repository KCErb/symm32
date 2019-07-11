module Symm32
  module PointIsometry
    # Re: PossibleIsometries
    # This shouldn't be necessary but I seem to be getting a bug when
    # saying that the @@instances hash should hold values of type
    # "Isometry" like this:
    # @@instances = Hash(String, Isometry).new
    # but the bug is gone if I limit the set like so:

    # :nodoc:
    alias PossibleIsometries = Identity | Inversion | Rotation | Mirror |
                               ImproperRotation
    @@instances = Hash(String, PossibleIsometries).new

    # Create isometry from 'minimal' string specification.
    #
    # Returns a singleton isometry since there is a finite
    # set of these and we'd like to use set theoretical concepts
    # when working with them.
    #
    # The `name_string` is a position-dependent string of numbers, letters,
    # and symbols which uniquely identifies an isometry. This was created
    # primarily for internal use, but I'll explain the scheme in case it
    # is useful externally for quickly creating an array of isometries.
    #
    # #### Name format of isometry string
    #
    # For example the string `-3d2^2` indicates a 3-fold improper rotation
    # (-3) about the 2nd diagonal (d2 - see `Axis` for the axis naming scheme)
    # which should be repeated twice (^2).
    #
    # Here's an ASCII guide:
    # ```text
    # -3d2^2
    # ^^^^^^
    # 1233^4
    # 1 - minus sign indicates invert after performing operation (bar)
    # 2 - kind of isometry:
    #   e - identity,
    #   i - point-inversion
    #   m - mirror plane (direction is of the normal)
    #   # - #-fold rotation (direction is of the axis)
    #   -# - #-fold *improper*-rotation (direction is of the axis)
    # 3 - direction of the isometry
    #   z - unique axis
    #   t - transverse plane from unique axis: t0, t30, t45, t60, ... t150
    #   d - diagonal (ex: 111 to -1-1-1): d1, d2, d3, d4)
    #   e - edge (ex: from 101 to 10-1): e1, e2, e3, e4)
    # 4 - if ^ is present, number of times to apply rotation (default is 1)
    # ```
    def self.parse(name_string)
      return @@instances[name_string] if @@instances[name_string]?
      # if not already in instances, add to instances keyed by name string
      kind, _, power = name_string.partition("^")
      if kind == "e"
        result = Identity.new
      elsif kind == "i"
        result = Inversion.new
      else
        bar = kind[0] == '-'
        axis = parse_axis(kind, bar)
        result = if kind[0] == 'm'
                   Mirror.new(axis)
                 else
                   init_rotation(bar, axis, kind, power)
                 end
      end
      @@instances[name_string] = result
    end

    private def self.parse_axis(direction, bar)
      # remove kind => mt30 => t30, -4z => z
      direction = bar ? direction[2..-1] : direction[1..-1]
      return Axis::ORIGIN if direction == "" # e and i have no axis

      dir_char = direction[0]
      return Axis::Z if dir_char == 'z'

      arg = direction.lchop.to_u8
      Axis.parse("#{dir_char}#{arg}")
    end

    private def self.init_rotation(bar, axis, kind, power)
      # 2, 3, 4, 6 or -2, -3, -4, -6 from stuff like 2z or 3d2
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
