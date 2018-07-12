module Symm32
  class PointGroup

    include Cardinality
    alias DirectionHash = Hash(Directions::Direction, Array(IsometryKind))

    @cardinality = IsometryCardinality.new
    @direction_hash = DirectionHash.new
    JSON.mapping(
      family: { type: String, setter: false },
      name: { type: String, setter: false },
      isometries: {type: Array(Isometry), setter: false}
    )

    getter direction_hash : DirectionHash

    # Create new point group object from array of isometry strings
    # the format of these strings is important and specified in isometry.cr
    def initialize(pull : JSON::PullParser)
      previous_def
      @cardinality = compute_cardinality
      @direction_hash = init_direction_hash
    end

    # Determine if this group is a subgroup of the one passed in
    def orientations_within(parent_group : PointGroup)
      return false unless has_min_cardinality?(parent.isometries)
      calculate_orientations(parent_group)
    end

    # Determine if the passed in array of isometries
    # meets the requirements of the group.
    def ==(isoArray : Array(Isometry))
      return false if isoArray.uniq.size != isoArray.size # no dupes
      return false unless cardinality_match?(isoArray)
      # cardinality covers these
      needs_checked = isoArray.reject { |iso| iso.inverse? || iso.identity? }
      # now we'll pass on the array of isometries to the requirements checker
      @requirements.meets?(needs_checked)
    end

    # Calculate all orientations of this group within the parent
    # returns an array of "direction" strings
    def calculate_orientations(parent_group)
      orientations = [] of Orientation
      # z_hash: IsometryKinds in z direction
      z_hash = direction_hash.select{ |d, _|d.orientation == Orientation::Z}
      z_kinds = z_hash.first_value
      # plane_cardinality = cardinality of isometries for all directions in T plane
      plane_hash = direction_hash.select { |d, _| d.class == Directions::Plane }
      plane_cardinality = compute_cardinality(plane_hash.values.flatten)

      # main loop
      parent_group.direction_hash.each do |direction, iso_kinds|
        # find axes in parent where my z-axis could go
        next unless (z_kinds - iso_kinds).empty?
        # for this axis, check if orthogonal plane has correct cardinality
        iso_arr = [] of Isometry
        direction.orthogonals.each do |orientation|
          iso_arr.concat parent_group.isometries_for_orientation(orientation)
        end
        parent_cardinality = compute_cardinality(iso_arr)
        next unless has_min_cardinality?(plane_cardinality, parent_cardinality)
        orientations << direction.orientation
      end
      orientations
    end

    # Directions Hash: hash of isometries in each direction (so, no identity or inverse)
    # example for 2/m
    #
    # {
    #   <Direction::Axial:0x563ef29e0fe0> => [
    #     IsometryKind::Rotation2,
    #     IsometryKind::Mirror
    # ]}
    private def init_direction_hash
      by_direction = @isometries.group_by { |iso| iso.direction }
      return by_direction.compact_map do |dir, iso_arr|
        {dir, iso_arr.map(&.kind)} if dir
      end.to_h
    end
  end
end
