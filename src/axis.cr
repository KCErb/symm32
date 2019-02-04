# This file uses the `enum object pattern`
# The enum `Axis` is an enum of Vector3 instances, these
# instances are stored in the `Axes` module as module constants.
#
# I developed this pattern because I first created the Axes module
# and slowly found myself implementing enum methods like `parse`
# and the helper methods like `origin?`. This pattern is also a better
# match for the underlying math: there are only a finite set of possible
# crystallographic axes.
module Symm32
  alias Vector3 = SymmBase::Vector3

  # :nodoc:
  module Axes
    Origin = Vector3.new(0, 0, 0)
    Z      = Vector3.new(0, 0, 1)
    # plane perpendicular to z
    T0   = Vector3.new(1, 0, 0)
    T30  = Vector3.new(Math::PI/2, Math::PI/6)
    T45  = Vector3.new(Math::PI/2, Math::PI/4)
    T60  = Vector3.new(Math::PI/2, Math::PI/3)
    T90  = Vector3.new(0, 1, 0)
    T120 = Vector3.new(Math::PI/2, Math::PI/3*2)
    T135 = Vector3.new(Math::PI/2, Math::PI/4*3)
    T150 = Vector3.new(Math::PI/2, Math::PI/6*5)
    # edges are counted clockwise from x-direction as you look down the z-axis on a cube
    E1 = Vector3.new(1, 0, 1).normalized
    E2 = Vector3.new(0, 1, 1).normalized
    E3 = Vector3.new(-1, 0, 1).normalized
    E4 = Vector3.new(0, -1, 1).normalized
    # diagonals are also counted clockwise starting from x-direction looking down z
    D1 = Vector3.new(1, 1, 1).normalized
    D2 = Vector3.new(-1, 1, 1).normalized
    D3 = Vector3.new(-1, -1, 1).normalized
    D4 = Vector3.new(1, -1, 1).normalized
  end

  # An enumerated list of 17 crystallographic axes + the origin.
  #
  # These are enums, but they forward all methods to an underlying `Vector3` object.
  # This way, we can use `Enum` methods like `parse` or `origin?` to treat
  # this as a finite set of objects, but we can also call `Vector3` methods
  # like `cross`. The result is that we can do math with these axes like so
  #
  # ```
  # Axis::X.cross(Axis::Y) # => SymmUtil::Vector3(@x=0.0, @y=0.0, @z=1.0)
  # ```
  #
  # There are many ways to name these axes. For convenience in writing and
  # working with this program, I've chosen a set of names which I'll now
  # explain carefully.
  #
  # ### Axis Names
  #
  # There are two ways of understanding the Axis names used in this program.
  # One is to simply read the source of the `Axes` module (in `axis.cr`),
  # I imagine that this method is sufficient for most physicists. The other
  # is for me to try to explain it in text here.
  #
  # The names can be visualized by imagining a cube. We first designate
  # the center of the cube as the `Origin`. All point isometries leave this point
  # unchanged. Next we select an axis which passes through the origin and the
  # center of a face and call this the `Z` axis.
  #
  # Now, consider the (centered) plane perpendicular to this axis
  # and call it `T` for transverse. `T0` is an axis in this plane which passes
  # through the center of a face. This is now the reference axis for the others.
  # `T30` will be an axis 30 degrees (counter-clockwise) from `T0`
  # and still in the T plane, `T45` is 45 degrees from `T0` and so on.
  # There are 8 of these.
  #
  # Next, looking down the z-axis (at the z-face) of the cube we would see a square.
  # We orient this square so that the edge corresponding to the T0 face is
  # on our right and the edge corresponding to T90 is on top. There are two
  # more kinds of axes we are interested in, those which pass through the center
  # of one of these 4 edges (as well as the `Origin`) and those which pass through
  # one of the 4 diagonals (and the `Origin`).
  #
  # The center-edge axes we'll call "edge" axes, and number them `E1`, `E2`,
  # `E3`, and `E4` with `E1` on our right (corresponding to the `T0` face), `E2`
  # on top (corresponding to the `T90` face), `E3` is on the left and `E4` on
  # the bottom.
  #
  # The diagonals are numbered `D1`, `D2` likewise, starting `D1` from the
  # top-right corner (corresponding to the `T45` axis) and continuing
  # counter-clockwise as before.
  #
  # Thus the enum is essentially this:
  # ```
  # enum Axis
  #   Origin # => {0, 0, 0}
  #   Z      # => {0, 0, 1}
  #   T0     # => {1, 0, 0}
  #   T30    # => {√3/2, 1/2, 0}
  #   T45    # => {√2/2, √2/2, 0}
  #   T60    # => {1/2, √3/2, 0}
  #   T90    # => {0, 1, 0}
  #   T120   # => {-1/2, √3/2, 0}
  #   T135   # => {-√2/2, √2/2, 0}
  #   T150   # => {-√3/2, 1/2, 0}
  #   E1     # => {1, 0, 1}
  #   E2     # => {0, 1, 1}
  #   E3     # => {-1, 0, 1}
  #   E4     # => {0, -1, 1}
  #   D1     # => {1, 1, 1}
  #   D2     # => {-1, 1, 1}
  #   D3     # => {-1, -1, 1}
  #   D4     # => {1, -1, 1}
  # end
  # ```
  enum Axis
    # The enum constants are just the constants in Axes (see above)
    {% for special_axis in Axes.constants %}
        {{special_axis.id}}
      {% end %}

    # Forwards missing methods to Axes::constant
    # if there are any args, convert all Axis enums to the
    # underlying Axes delegate. This doesn't handle named args or blocks.
    macro method_missing(call)
        case self
      {% for special_axis in Axes.constants %}
        when {{special_axis}}
        {% if call.args.size > 0 %}
          args = Tuple.new({{call.args.splat}})
          tuple_args = args.map do |arg|
            arg.is_a?(Axis) ? arg.delegate : arg
          end
          Axes::{{special_axis}}.{{call.name}}(*tuple_args)
        {% else %}
          Axes::{{special_axis}}.{{call}}
        {% end %}
      {% end %}
        else
          raise "enum object pattern failure"
        end
      end

    # The underlying `Vector3` object of this Axis (enum).
    def delegate
      {% begin %}
        case self
          {% for special_axis in Axes.constants %}
            when {{special_axis}}
              Axes::{{special_axis}}
          {% end %}
        else
          raise "enum object pattern failure"
        end
      {% end %}
    end

    # ditto
    def coordinates
      delegate
    end

    # Is this Axis in the T-plane?
    def planar?
      plane.includes?(self)
    end

    # Is this Axis an edge?
    def edge?
      {E1, E2, E3, E4}.includes?(self)
    end

    # Is this Axis a diagonal?
    def diagonal?
      {D1, D2, D3, D4}.includes?(self)
    end

    # Array of axes orthogonal to this one.
    #
    # The order of the returned array was hand selected to be
    # internally consistent. To reproduce, look down
    # the axis and note the axes orthogonal to it.
    # You'll find that they are not evenly distributed but rather
    # clumped together, start with the "first" axis in that clump
    # so that the largest gap between two axes would be traversed
    # last going counter-clockwise around the axis.
    def orthogonal
      case
      when origin?
        [] of Axis
      when z?
        plane
      when t0?
        [T90, E2, Z, E4]
      when t30?
        [T120, Z]
      when t45?
        [T135, D2, Z, D4]
      when t60?
        [T150, Z]
      when t90?
        [E3, Z, E1, T0]
      when t120?
        [Z, T30]
      when t135?
        [D3, Z, D1, T45]
      when t150?
        [Z, T60]
      when e1?
        [T90, D2, E3, D3]
      when e2?
        [D3, E4, D4, T0]
      when e3?
        [D4, E1, D1, T90]
      when e4?
        [T0, D1, E2, D2]
      when d1?
        [T135, E3, E4]
      when d2?
        [E4, E1, T45]
      when d3?
        [E1, E2, T135]
      when d4?
        [T45, E2, E3]
      else
        raise "enum object pattern failure"
      end
    end

    private def plane
      [T0, T30, T45, T60, T90, T120, T135, T150]
    end
  end
end
