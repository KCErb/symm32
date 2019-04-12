require "./axis"
require "./axis_kind"
require "./direction"
require "./family"

module Symm32
  # A [crystallographic point group](https://en.wikipedia.org/wiki/Crystallographic_point_group).
  # All 32 are created and stored in the `Symm32::POINT_GROUPS` constant.
  #
  # A point group extends a SymmGroup by including the notions of family
  # and direction. See docs for `Family` and `Direction` for more info.
  class PointGroup < SymmBase::SymmGroup
    getter family : Family
    getter directions : Array(Direction)

    private alias IsoHash = Hash(SymmBase::Isometry, SymmBase::Isometry)
    @inverses_hash = IsoHash.new
    # nested hash that acts like a 2D nested table where we index by isometry rather than number
    private alias Hash2DIsometry = Hash(SymmBase::Isometry, IsoHash)
    @multiplication_table = Hash2DIsometry.new

    def initialize(@family, @name, isometries_arr)
      super(@name, isometries_arr)
      @directions = init_directions
      @family.classify_directions(@directions)
      init_inverses
      init_multiplication_table
    end

    # Creates a point group from "minimal" strings.
    #
    # This method is primarily used by POINT_GROUPS constant
    # you shouldn't need it.
    def self.parse(family, name, isometry_strings)
      isometries = [] of SymmBase::Isometry
      isometry_strings.each { |iso_string| isometries << PointIsometry.parse(iso_string) }
      new(Family.parse(family), name, isometries)
    end

    # left action convention means product(iso1, iso2) => apply iso2 and then apply iso1
    def product(iso1, iso2)
      @multiplication_table[iso1][iso2]
    end

    def inverse(iso)
      @inverses_hash[iso]
    end

    def centrosymmetric?
      isometries.map(&.kind).includes? :inversion
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

    # Returns an array of isometries in a given axis.
    def select_direction(axis : Axis)
      directions.find { |d| d.axis == axis }
    end

    # Finds the first direction that is parallel to coordinates.
    def select_direction(coords : Vector3)
      directions.find do |dir|
        dir.axis.cross(coords).nearly_zero?
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

    def to_s(io)
      io << "#<PointGroup @family=\"#{family}\" @name=\"#{name}\" >"
    end

    def inspect(io)
      to_s(io)
    end

    private def init_directions
      by_axis = isometries.group_by { |iso| iso.responds_to?(:axis) ? iso.axis : Axis::Origin }
      dirs = by_axis.compact_map do |axis, iso_arr|
        next if axis == Axis::Origin
        Direction.new(axis, iso_arr)
      end
      dirs.sort_by(&.axis)
    end

    private def init_inverses
      isometries.each do |iso|
        rot_hash = parse_rotation(iso)
        next @inverses_hash[iso] = iso unless rot_hash
        next @inverses_hash[iso] = iso if rot_hash[:n_fold] == 2
        inv_kind = "#{rot_hash[:base]}#{rot_hash[:n_fold]}"
        if rot_hash[:power] == 1
          power = rot_hash[:n_fold] - 1
          inv_kind += "_#{power.to_s}"
        end

        iso_inv = isometries.find do |i|
          res = i.kind.to_s == inv_kind
          if iso.responds_to?(:axis) && i.responds_to?(:axis)
            res &= i.axis == iso.axis
          end
          res
        end.not_nil!
        @inverses_hash[iso] = iso_inv
      end
    end

    # MULTIPLICATION TABLE
    # -  This is in regular representation order, so the columns are in any order
    #    starting with identity
    # -  Rotations are active and use the standard x->y counter-clockwise convention.
    #    Therefore, the product of 3 * 2_T30 for example in PG 32 is 2_T90 instead of
    #    2_T150 which we'd get from a clockwise rotation or passive rotation as seems
    #    to be common in the chemistry references I've seen.
    private POLAR         = Math::PI/2 - Math::PI/23
    private AZIMUTHAL     = Math::PI/2 - Math::PI/17
    private COORDS        = SymmBase::Vector3.new(POLAR, AZIMUTHAL)
    GENERAL_POINT = ChiralPoint.new(COORDS)

    private def init_multiplication_table
      # note that the following means subclasses just need to define GENERAL_POINT
      # and then the rest comes from here:
      general_point = {% begin %}{{ @type }}::GENERAL_POINT{% end %}
      # turn isometries into points for multiplication by transformation
      mult_map = Hash(SymmBase::Isometry, SymmBase::Point).new
      isometries.each do |iso|
        mult_map[iso] = iso.transform(general_point)
      end

      # fill the table with results from the map
      size = isometries.size
      @multiplication_table = Hash2DIsometry.new
      isometries.each do |inv_row_iso|
        row_iso = @inverses_hash[inv_row_iso]
        @multiplication_table[row_iso] = IsoHash.new
        isometries.each do |col_iso|
          point = row_iso.transform(col_iso.transform(general_point))
          @multiplication_table[row_iso][col_iso] = mult_map.key_for(point)
        end
      end
    end

    # turns a rotation kind symbol into a useful hash
    private def parse_rotation(iso)
      match = iso.kind.to_s.match(/(.*rotation_)(\d.*)/)
      return match unless match
      suffix = match[2]
      n_fold = suffix[0].to_i
      power = suffix.size > 1 ? suffix[2].to_i : 1
      { base: match[1], n_fold: n_fold, power: power}
    end
  end
end
