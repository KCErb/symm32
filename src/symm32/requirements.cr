module Symm32
  # Describe the requirements that a group imposes on its members
  class Requirements
    getter axis_requirement
    getter plane_requirement
    # A plane is defined relative to an axis.
    # The members of the axis are required
    # The angles between plane members are required
    def initialize(isometries)
      axis_elements = isometries.select(&.axis?)
      @axis_requirement = AxisRequirement.new(axis_elements)
      plane_elements = isometries.select(&.plane?)
      @plane_requirement = PlaneRequirement.new(plane_elements)
    end

    def build_requirement(isometry)
      Requirement.new(isometry)
    end

    # find number of possible unique axes in other
    # go through each one and see if the plane requirements can be met with that as the chosen axis
    def meets?(other : Array(Isometry))
      possibilities = other.group_by { |iso| iso.direction }
      result = possibilities.each do |direction, isometry_arr|
        next unless @axis_requirement.met_by?(isometry_arr)
        break true if @plane_requirement.met_by?(direction, other)
      end
      return result || false
    end
  end

  # TODO: Both kinds of requirements share the kinds and isometries properties
  # so they could probably share a parent.
  class AxisRequirement
    getter kinds : Array(String)
    def initialize(@isometries : Array(Isometry))
      @kinds = @isometries.map { |i| i.kind }.sort
    end

    # The axial requirement stores the kinds of elements in the special axis as @kinds
    # so met_by? just tells us if the passed in array has the right kinds
    def met_by?(other : Array(Isometry))
      other.map { |iso| iso.kind }.sort == @kinds
    end
  end

  class PlaneRequirement
    @kinds : Array(String)
    # angles are evenly spaced in plane thanks to symmetry
    # so we just need to know what that spacing angle is
    def initialize(@isometries : Array(Isometry))
      @spacing = {} of String => Int32
      @kinds = @isometries.map { |i| i.kind }.sort
      return if @isometries.empty? || @isometries.size == 1
      init_spacing
    end

    # check elements which `other` has in plane normal to `direction`
    def met_by?(direction, other : Array(Isometry))
      return true if @spacing.empty?
      in_plane = other.select { |iso| iso.in_plane?(direction) }
      # TODO cardinality check?
      return false if !cardinality_ok?(in_plane)
      spacing_ok?(in_plane)
    end

    private def init_spacing
      by_kind = @isometries.group_by { |i| i.kind  }

      by_kind.each do |kind, iso|
        plane_angles = @isometries.map { |iso| iso.plane_angle }
        unique_angles = plane_angles.uniq.sort
        # Crystal is still a work in progress so this nil check is for the compiler
        @spacing[kind] = unique_angles[1] - unique_angles[0]
      end
    end

    # find smallest angle in plane, ensure that it's equal to spacing
    # if it's equal to the spacing then we are set since the cardinality
    # requirement guarantees that they will be evenly distributed. I think...
    private def spacing_ok?(isometries : Array(Isometry))
      # separate by kind
      by_kind = isometries.group_by { |i| i.kind }
      results = by_kind.map do |kind, iso_arr|
        return true if iso_arr.size == 1
        result = iso_arr.combinations(2).map do |pair|
          pair[0].angle_from(pair[1])
        end
        result.sort!
        (result[0] * 180 / Math::PI).round(10) == @spacing[kind]
      end
      results.all?
    end
  end
end
