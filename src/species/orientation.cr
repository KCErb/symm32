module Symm32
  struct Orientation
    getter child : PointGroup
    getter parent : PointGroup
    # parent may not have any direction since directions have axes
    @parent_direction : Direction | Nil

    # map of child direction to parent direction, i.e. map[z]
    # would give you the direction in the parent that the child's z
    # is embedded in, in this orientation
    property map = Hash(Direction, Direction).new

    # A little flag for marking orientations as bad, used by the factory
    # to help toss out an orientation that fails checks
    property? valid = true

    def initialize(@child, @parent, parent_direction = nil)
      @parent_direction = parent_direction
      if parent_direction
        child_z_direction = child.select_direction(Axis::Z)
        @map[child_z_direction] = parent_direction if parent_direction && child_z_direction
      end
    end

    def parent_classification
      parent_dir = @parent_direction
      parent_dir ? parent_dir.classification : AxisKind::None
    end

    # Complete the map between parent and child using an array of parent
    # directions which map to the child's planar directions
    def complete(parent_plane)
      child_plane = child.plane
      raise "Plane is wrong size." if parent_plane.size != child_plane.size
      orient_plane(child_plane, parent_plane)
      handle_cubic(parent_plane) if child.family.cubic?
    end

    private def orient_plane(child_plane, parent_plane)
      child_plane.each_with_index do |child_dir, index|
        map[child_dir] = parent_plane[index]
      end
    end

    # finds new basis vectors relative to orientation of x and z
    private def handle_cubic(parent_plane)
      z_hat = @parent_direction.not_nil!.axis.normalized
      x_hat = parent_plane[0].axis.normalized
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
        map[child_dir] = parent_dir
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
      return %Q{Origin => {#{child.isometries.map(&.kind).join(" | ")}}} if map.empty?
      # sort to axis enum value for consistency
      sorted = map.to_a.sort_by { |k, v| v.axis.value }.to_h
      fingerprint = ""
      sorted.each do |child_direction, parent_direction|
        fingerprint += "#{parent_direction.classification} => {#{child_direction.flag}} "
      end
      fingerprint
    end

    def hash
      fingerprint.hash
    end

    def ==(other : Orientation)
      hash == other.hash
    end
  end
end
