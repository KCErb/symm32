# This file uses the enum object pattern, see README
module Symm32
  # Special crystallographic axes
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
    E1 = Vector3.new(1, 0, 1)
    E2 = Vector3.new(0, 1, 1).normalized
    E3 = Vector3.new(-1, 0, 1).normalized
    E4 = Vector3.new(0, -1, 1).normalized
    # diagonals are counted similarly, clockwise starting from x direction looking down z
    D1 = Vector3.new(1, 1, 1).normalized
    D2 = Vector3.new(-1, 1, 1).normalized
    D3 = Vector3.new(-1, -1, 1).normalized
    D4 = Vector3.new(1, -1, 1).normalized
  end

  # An enumerated list of objects (Vector3)
  # the constants here forward method_missing to the constants in Axes
  enum Axis
    {% for special_axis in Axes.constants %}
        {{special_axis.id}}
      {% end %}

    # forward missing methods to Axes::constant
    # if there are any args, convert all Axis enums to the
    # underlying Axes delegate. This doens't handle named args or blocks etc.
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
          raise "error impossible"
        end
      end

    def delegate
      {% begin %}
          case self
        {% for special_axis in Axes.constants %}
          when {{special_axis}}
            Axes::{{special_axis}}
        {% end %}
          else
            raise "error impossible"
          end
        {% end %}
    end

    def planar?
      plane.includes?(self)
    end

    def edge?
      {E1, E2, E3, E4}.includes?(self)
    end

    def diagonal?
      {D1, D2, D3, D4}.includes?(self)
    end

    # array of axes orthogonal to this one
    # the **order is very important**, it is used to infer the different planar
    # orientations by assuming that they are in clockwise order with respect
    # to the axis and some starting point.
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
        raise "error impossible"
      end
    end

    private def plane
      [T0, T30, T45, T60, T90, T120, T135, T150]
    end
  end
end
