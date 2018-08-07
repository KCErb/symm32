module Symm32
  class OrientationFactory

    getter child : PointGroup
    getter parent : PointGroup
    @child_plane : Array(Direction)

    def initialize(@child, @parent)
      @orientations = [] of Orientation
      @child_plane = child.plane
    end

    def calculate_orientations
      return @orientations unless child.fits_within?(parent)
      child_z_direction = child.select_direction(Axis::Z)
      return handle_no_z unless child_z_direction

      # iterate through parent directions, finding possible orientations of
      # child's Z axis and subsequently its T plane in the parent
      parent.directions.each do |parent_direction|
        next unless is_valid?(parent_direction, child_z_direction)
        build_orientations_in(parent_direction)
      end
      @orientations.uniq!
    end

    # The child has no z, so we return a special orientation for identity and
    # inversion groups which has a nil "parent_direction"
    private def handle_no_z
      [Orientation.new(child, parent)]
    end

    # this orientation is unique from parent's perspective?
    # this orientation fits cardinality-wise?
    private def is_valid?(parent_direction, child_z_direction)
      valid = true
      valid &= is_unique?(parent_direction)
      valid &= child_z_direction.count_fits(parent_direction) > 0
    end

    private def build_orientations_in(parent_direction)
      orientation = Orientation.new(child, parent, parent_direction)
      return @orientations << orientation if @child_plane.empty?
      orient_remaining(orientation, parent_direction)
    end

    # orient the rest of the child elements somewhere in the parent
    private def orient_remaining(orientation, parent_direction)
      plane_subsets(parent_direction).each do |plane|
        new_orientation = orientation.clone
        new_orientation.complete(plane)
        @orientations << new_orientation if new_orientation.valid?
      end
    end

    # There are two kinds of ways the parent plane could fit into the child plane
    # since these are non-obvious I'll explain by example
    #
    #   1. Let's say the child plane has 2-fold rotations at T0 and T90
    #      and the parent has 2-fold rotations at T0 T45 T90 and T135.
    #      Let's call these ABCD, then the correct subsets are [AC, BD]
    #      meaning we map T0 and T90 first to themselves and then to T45 and T135
    #   2. Now let's say that the child plane has 2,m,2,m: 4 plane isometries
    #      at T0, T45, etc. And the parent has both 2 and m on each of those 4 axes
    #      then the correct subsets are ABCD and BCDA
    #
    # Thus we have two methods for determining subsets as seen below.
    private def plane_subsets(parent_direction)
      parent_plane = parent.directions_perp_to(parent_direction.axis)
      fits = Cardinality.count_fits_arr(@child_plane, parent_plane)
      return [] of Array(Direction) unless fits > 0

      step_size = parent_plane.size / @child_plane.size

      if fits <= step_size
        plane_subsets_method_1(step_size, fits, parent_plane)
      else
        plane_subsets_method_2(fits, parent_plane)
      end
    end

    # See docs for plane_subsets
    # We achieve the AC, BD pattern by the modulus of the index i
    # we track classification to ensure parent only returns
    # unique subsets from its perspective
    private def plane_subsets_method_1(step_size, fits, parent_plane)
      subsets = [] of Array(Direction)
      classifications = [] of CrystalFamily::Classification
      i = 0
      groups = parent_plane.group_by { |dir| i += 1; i % step_size }
      groups.each do |_, plane|
        classification = plane[0].classification
        next if classifications.includes? classification
        classifications << classification
        subsets << plane
      end
      # if fits < step_size, then step_size produces too many fits so we s
      subsets = subsets[0, fits] if fits < step_size
      subsets
    end

    # See docs for plane_subsets
    # We achieve the ABCD, BCDA pattern by shuffling the array
    # we track classification to ensure parent only returns
    # unique subsets from its perspective
    private def plane_subsets_method_2(fits, parent_plane)
      subsets = [] of Array(Direction)
      classifications = [] of CrystalFamily::Classification
      fits.times do
        classification = parent_plane[0].classification
        next if classifications.includes? classification
        classifications << classification
        subsets << parent_plane.clone
        # shuffle front to back
        last = parent_plane.shift
        parent_plane << last
      end
      subsets
    end

    # Does this array of orientations already have an orientation
    # with this parent's classification?
    private def is_unique?(parent_direction)
      index = @orientations.index do |orientation|
        orientation.parent_classification == parent_direction.classification
      end
      index.nil? # if index is nil, then this is unique
    end
  end
end
