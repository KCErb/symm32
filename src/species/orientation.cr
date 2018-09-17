module Symm32
  struct Orientation
    getter child : PointGroup
    getter parent : PointGroup
    # The direction in the parent where the Z direction of the child goes.
    # Parent may not have any direction since directions have axes
    @parent_direction : Direction | Nil

    # correspondence of child direction to parent direction,
    # { child => parent }
    # i.e. correspondence.first will often be the following key value pair:
    #     child's z-direction => parent_direction (often z)
    # or if the child's z direction is in the paren't plane:
    #     child's z-direction => parent's T0 direction (parent_direction)
    property correspondence = Hash(Direction, Direction).new

    # child is oriented with its z-axis along some direction
    # in the parent, the parent classifies this direction
    # from there the plane can be oriented (rotated if you will about the z)
    # and each of these orientations can also be classified by the parent
    # we default to none since some species have no axis or no plane.
    property axis_classification = AxisKind::None
    property plane_classification = AxisKind::None

    # A little flag for marking orientations as bad, used by the factory
    # to help toss out an orientation that fails checks
    property? valid = true

    def initialize(@child, @parent, parent_direction = nil)
      @parent_direction = parent_direction
      if parent_direction
        child_z_direction = child.select_direction(Axis::Z)
        @correspondence[child_z_direction] = parent_direction if child_z_direction
        @axis_classification = parent_direction.classification
      end
    end

    # Complete the correspondence between parent and child using an array of parent
    # directions which map to the child's planar directions
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

    # Sorta like a to_s, except we're using flags and classifications which
    # will reduce identical orientations in different representations to
    # the same string. Thus, this has more to do with the uniqueness of
    # the orientation and less to do with a string representation of it.
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
