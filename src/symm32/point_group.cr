module Symm32
  class PointGroup
    include Cardinality(PointGroup)
    @directions = Array(Direction).new
    @family = CrystalFamily.new
    JSON.mapping(
      name: {type: String, setter: false},
      isometries: {type: Array(Isometry), setter: false}
    )

    getter directions
    getter family : CrystalFamily

    # Create new point group object from array of isometry strings
    # the format of these strings is important and specified in isometry.cr
    def initialize(pull : JSON::PullParser)
      previous_def
      @cardinality = init_cardinality
      @directions = init_directions
    end

    # some things we can't init until we have a family which we don't have until
    # after initialization, see the root symm32.cr
    # so we put it here in the setter.
    def family=(fam : CrystalFamily)
      fam.classify_directions(self)
      @family = fam
    end

    # Determine if this group is a subgroup of the one passed in
    def orientations_within(parent : PointGroup)
      factory = OrientationFactory.new(self, parent)
      factory.calculate_orientations
    end

    def plane
      directions_perp_to(Axis::Z)
    end

    def edges
      select_directions([Axis::E1, Axis::E2, Axis::E3, Axis::E4])
    end

    def diags
      select_directions([Axis::D1, Axis::D2, Axis::D3, Axis::D4])
    end

    # get array of isometries in given axis
    def select_direction(axis : Axis)
      directions.find { |d| d.axis == axis }
    end

    # find the first direction that is parallel to coords
    def select_direction(coords : Vector3)
      directions.find do |dir|
        next if dir.axis == Axis::None
        dir.axis.cartesian.cross(coords).zero?
      end
    end

    # array of directions on axes
    def select_directions(axes)
      directions.select { |d| axes.includes?(d.axis) }
    end

    # get array of isometries perpendicular to direction
    def directions_perp_to(axis)
      plane = axis.orthogonal
      res = directions.select { |d| plane.includes?(d.axis) }
      # sort according to axis order
      res.sort_by { |d| plane.index(d.axis).not_nil! }
    end

    # Ex: if own axis is t0 and relative axis is t0, then that means
    # I want to treat my own t0 as z, and then find the t0 axis in that
    # context. The answer depends on the group but in general this is specifying
    # a group of directions that could fit the bill.
    def relative_directions(own_axis : Axis, relative_axis : Axis)
      polar = relative_axis.spherical[1]
      axes = own_axis.axes_at_angle(polar)
      select_directions(axes)
    end

    private def init_directions
      by_axis = isometries.group_by { |iso| iso.axis }
      dirs = by_axis.compact_map do |axis, iso_arr|
        Direction.new(axis, iso_arr)
      end
      dirs.sort_by(&.axis)
    end
  end
end
