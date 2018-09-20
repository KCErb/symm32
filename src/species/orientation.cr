module Symm32
  # The orientation of a `child` point group within a `parent` point group.
  #
  # The `#correspondence` Hash is a key -> value pair showing how
  # each child direction is mapped to a parent direction.
  #
  # For example, consider point group `2` and its orientations in `422`.
  # The 2-fold axis of `2` could either correspond to the axial 2-fold
  # axis in `422` or the planar one. Thus for the axial orientation the
  # correspondence would store { Z => Z } and for the planar it would
  # store { Z => T0 } since T0 is the default orientation in this situation.
  #
  # Two important things to note here:
  # 1. In 422, there are 3 other planar 2-fold axes we could have chosen.
  #   These are all equivalent from the perspective of the parent (422).
  # 2. In the above mappings I wrote { Z => T0 } for convenience. The map
  #   is actually between `Direction`s and thus a `Hash` isn't necessarily
  #   the best way to think of this, since you'd have to have the
  #   correct instance of `Direction` in order to actually "look up"
  #   the corresponding `Direction`. If someone comes up with a use case
  #   where syntax like `orientation.correspondence[Axis::Z]` would be
  #   helpful, I'd be very open to the contribution.
  struct Orientation
    getter child : PointGroup
    getter parent : PointGroup

    # The direction in the parent where the Z direction of the child goes.
    # Parent may not have any direction since directions have axes
    @parent_direction : Direction | Nil

    # correspondence of child direction to parent direction,
    # { child => parent }
    # i.e. `correspondence.first` will often be the following key value pair:
    # child's z-direction => parent_direction (often z)
    # or if the child's z direction is in the paren't plane:
    # child's z-direction => parent's T0 direction (parent_direction)
    property correspondence = Hash(Direction, Direction).new

    # Parent's classification of the direction in which the child has
    # placed its z-axis.
    #
    # The child is oriented with its z-axis along some direction
    # in the parent (if it has any directions at all that is).
    # The parent possesses a classification for this direction.
    # In the example given in this class's "Overview" we considered 2 in
    # 422. In the axial orientation, the `axial_classification` would be
    # `AxisKind::Axial`, in the planar orientation, because the child's
    # Z-direction is in the plane, the `axial_classification` would be
    # `AxisKind::Planar`
    property axis_classification = AxisKind::None

    # Similar to `axis_classification`. This is an `AxisKind` which
    # communicates how the parent group views the orientation of the child's
    # T-plane.
    #
    # Once the child's Z-axis has been placed in the parent, the only degree
    # of freedom remaining is the rotation of its T-plane elements about
    # that axis. We can consider the first T-plane axis (usually T0) and
    # determine parent's classification of that direction.
    #
    # In practice, this only is relavent for cubic parents.
    property plane_classification = AxisKind::None

    # A little flag for marking orientations as bad, used by the factory
    # to help toss out an orientation that fails checks.
    property? valid = true

    def initialize(@child, @parent, parent_direction = nil)
      @parent_direction = parent_direction
      if parent_direction
        child_z_direction = child.select_direction(Axis::Z)
        @correspondence[child_z_direction] = parent_direction if child_z_direction
        @axis_classification = parent_direction.classification
      end
    end

    # How should the parent adjust the name of the child to give it
    # a distinct name based on orientation?
    #
    # For example, if the parent
    # is 422 it has 2 children for point group 2. So it will name
    # the one oriented along the axis "2|" and the one oriented in
    # the plane "2_". These strings come from `AxisKind#symbol`
    def child_name
      name = child.name
      name += axis_classification.symbol
      name += plane_classification.symbol if parent.family.cubic?
      name
    end

    # Determine if an orientation could be considered a "subset" of this one.
    #
    # Self is a subset of other if:
    # 1. They share the same parent
    # 2. Self can be oriented within other and retain orientation within parent.
    #
    # Example: orientation of 4 within 4/mmm requires z orientation of 4
    # orientation of 2 within 4 requires z orientation of 2, but orientation of 2
    # within 4/mmm can be either in z (2|) or in plane (2_). Thus 2|
    # is a subset of 4 (wrt 4/mmm) but 2_ is not.
    def subset?(other : Orientation)
      return false if parent != other.parent
      return false unless child.fits_within?(other.child) # origin cardinality
      return true unless @parent_direction                # if no dir, then origin check was enough
      # ensure that for all directions an equivalent direction can be found
      # in other (equiv. wrt. common parent)
      correspondence.all? do |child_dir, parent_dir|
        top_dirs = other.correspondence.select do |_, top_parent_dir|
          parent_dir.classification == top_parent_dir.classification
        end
        top_dirs.any? { |dir_tuple| child_dir.fits_within? dir_tuple.first }
      end
    end

    # Complete the correspondence between parent and child using an array of parent
    # directions which map to the child's planar directions. The `OrientationFactory`
    # is used for generating the `parent_plane` in a useful order.
    # This method will mark an orientation as invalid if the
    # suggested mapping doesn't actually work.
    def complete(parent_plane)
      child_plane = child.plane
      raise "Plane is wrong size." if parent_plane.size != child_plane.size
      orient_plane(child_plane, parent_plane)
      handle_cubic(parent_plane) if child.family.cubic?
      @plane_classification = parent_plane.first.classification
    end

    private def orient_plane(child_plane, parent_plane)
      child_plane.each_with_index do |child_dir, index|
        correspondence[child_dir] = parent_plane[index]
      end
    end

    # finds new basis vectors relative to orientation of x and z
    private def handle_cubic(parent_plane)
      z_hat = @parent_direction.not_nil!.axis.normalized
      x_hat = parent_plane.first.axis.normalized
      y_hat = z_hat.cross x_hat
      orient_non_planar(x_hat, y_hat, z_hat)
    end

    # looks at each diag/edge direction and converts it in the new coords
    # to determine if parent has a direction parallel to this axis
    # marks orientation as invalid if orientation can't be completed
    private def orient_non_planar(x_hat, y_hat, z_hat)
      non_planar = child.edges.concat child.diags
      non_planar.each do |child_dir|
        break unless valid?
        x, y, z = child_dir.axis.values
        parent_coords = x_hat * x + y_hat * y + z_hat * z
        parent_dir = parent.select_direction(parent_coords)
        break self.valid = false unless parent_dir
        correspondence[child_dir] = parent_dir
      end
    end

    def clone
      self.class.new(@child, @parent, @parent_direction)
    end

    # Generates a unique string for this orientation which is guaranteed to
    # be identical for equivalent orientations.
    #
    # For example, species 422 => 2_ (#34) can have 4 equivalent `Orientation`
    # objects. One for each of the planar axes that the 2-fold axis could
    # correspond to. This method turns that species into the following
    # string:
    # ```text
    #  Planar => {Set{Rotation2}}
    # ```
    # This string will be identical for all 4 orientations because it is
    # generated by naming the sets of IsometryKinds and the parent's
    # classification of each set.
    def fingerprint
      return %Q{Origin => {#{child.isometries.map(&.kind).join(" | ")}}} if correspondence.empty?
      # sort to axis enum value for consistency
      sorted = correspondence.to_a.sort_by { |k, v| v.axis.value }.to_h
      fingerprint = ""
      sorted.each do |child_direction, parent_direction|
        fingerprint += "#{parent_direction.classification} => {#{child_direction.kinds}} "
      end
      fingerprint
    end

    def_hash fingerprint

    def ==(other : Orientation)
      fingerprint == other.fingerprint
    end
  end
end
