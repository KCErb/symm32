# This file uses the enum object pattern, see README
module Symmetry
  module Crystallographic
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
      E2 = Vector3.new(0, 1, 1)
      E3 = Vector3.new(-1, 0, 1)
      E4 = Vector3.new(0, -1, 1)
      # diagonals are counted similarly, clockwise starting from x direction looking down z
      D1 = Vector3.new(1, 1, 1)
      D2 = Vector3.new(-1, 1, 1)
      D3 = Vector3.new(-1, -1, 1)
      D4 = Vector3.new(1, -1, 1)
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

      # Get back the integers to the right of type, T90 => 90, E4 => 4
      # raise error if not available (Z, None)
      private def arg_int
        num = to_s.lchop
        res = num.to_u8?
        raise "Can't call arg_int on `#{to_s}`" unless res
        res
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

      private def plane
        [T0, T30, T45, T60, T90, T120, T135, T150]
      end
    end
  end
end
