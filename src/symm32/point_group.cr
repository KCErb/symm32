module Symm32
  # A [crystallographic point group](https://en.wikipedia.org/wiki/Crystallographic_point_group).
  # All 32 are created and stored in the `Symm32::POINT_GROUPS` constant.
  #
  # A point group is a `Set` of `Isometry`s. It has a `Cardinality`
  # and an array of `Direction`s. It also has a `Family`.
  class PointGroup
    getter family : Family
    # Almost Hermann–Mauguin notation name. We just replace the overbar symbol
    # with "b" to make ASCII friendly. Ex.: inversion group => 1b
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

    # Creates a point group from "minimal" strings.
    #
    # This method is primarily used by POINT_GROUPS constant
    # you shouldn't need it.
    def self.parse(family, name, isometry_strings)
      isometries = [] of Isometry
      isometry_strings.each { |iso_string| isometries << Isometry.parse(iso_string) }
      new(Family.parse(family), name, isometries)
    end

    # Does this point group have the inversion operation?
    def inverse?
      isometries.includes? Isometry::INVERSION
    end

    # Returns an array of directions in the T-plane (see `Axis`).
    def plane
      directions_perp_to(Axis::Z)
    end

    # Returns an array of Edge directions (see `Axis`).
    def edges
      select_directions([Axis::E1, Axis::E2, Axis::E3, Axis::E4])
    end

    # Returns an array od Diagonal directions (see `Axis`).
    def diags
      select_directions([Axis::D1, Axis::D2, Axis::D3, Axis::D4])
    end

    # Returns the size of the isometries array.
    def order
      isometries.size
    end

    # Returns an array of isometries in a given axis.
    def select_direction(axis : Axis)
      directions.find { |d| d.axis == axis }
    end

    # Finds the first direction that is parallel to coordinates.
    def select_direction(coords : Vector3)
      directions.find do |dir|
        dir.axis.cross(coords).zero?
      end
    end

    # Returns an array of directions which are in the given axes.
    def select_directions(axes : Array(Axis))
      directions.select { |d| axes.includes?(d.axis) }
    end

    # Returns array of isometries perpendicular to an axis
    def directions_perp_to(axis : Axis)
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
