module Symm32
  class PointGroup
    getter family : Family
    # almost Hermann–Mauguin notation, just replace "bar" with "b" to make ASCII friendly
    # as in 3 with a line over it is replaced with 3b
    getter name : String
    getter isometries = Set(Isometry).new
    include Cardinality(PointGroup)
    getter directions : Array(Direction)

    def initialize(@family, @name, isometries_arr)
      isometries_arr.each { |iso| @isometries << iso }
      @cardinality = init_cardinality
      @directions = init_directions
      @family.classify_directions(@directions)
    end

    # create point group from minimal strings, used by POINT_GROUPS constant
    def self.parse(family, name, isometry_strings)
      isometries = [] of Isometry
      isometry_strings.each { |iso_string| isometries << Isometry.parse(iso_string) }
      new(Family.parse(family), name, isometries)
    end

    def inverse?
      isometries.includes? Isometry::INVERSION
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

    def order
      isometries.size
    end

    # get array of isometries in given axis
    def select_direction(axis : Axis)
      directions.find { |d| d.axis == axis }
    end

    # find the first direction that is parallel to coords
    def select_direction(coords : Vector3)
      directions.find do |dir|
        dir.axis.cross(coords).zero?
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

    private def init_directions
      by_axis = isometries.group_by { |iso| iso.responds_to?(:axis) ? iso.axis : Axis::Origin }
      dirs = by_axis.compact_map do |axis, iso_arr|
        next if axis == Axis::Origin
        Direction.new(axis, iso_arr)
      end
      dirs.sort_by(&.axis)
    end
  end
end
