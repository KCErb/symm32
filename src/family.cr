module Symm32
  # The primary purpose of this enum is to classify isometries
  # in a group according to the summit of the family, for example
  # in the tetragonal group, we can classify the 2-fold axis
  # of group 4 as 2-axial because in 4/mmm there is also
  # 2-planar. This is important for species distinctions. (See `#classify_directions` for more info.)
  enum Family
    Triclinic
    Monoclinic
    Orthorhombic
    Tetragonal
    Hexagonal
    Cubic

    # Classify an array of `Direction`s based on family of directions.
    #
    # Since this is an enum method, a `PointGroup` which has this enum as its
    # `family` can call on the family to classify its directions (as an
    # `AxisKind`).
    # The default is `AxisKind::None` so we only add one of the other kinds
    # if the family is axial (Tetragonal or Hexagonal) or cubic.
    #
    # See `AxisKind` documentation for more details on the different axis
    # kinds and when they are applied.
    def classify_directions(directions)
      case self
      when Tetragonal, Hexagonal
        classify_axial(directions)
      when Cubic
        classify_cubic(directions)
      end
    end

    private def classify_axial(directions)
      directions.each do |dir|
        is_axial = dir.axis.z?
        dir.classification = is_axial ? AxisKind::Axial : AxisKind::Planar
      end
    end

    private def classify_cubic(directions)
      directions.each do |dir|
        on = [Axis::Z, Axis::T0, Axis::T90].includes?(dir.axis)
        dir.classification = on ? AxisKind::OnAxes : AxisKind::OffAxes
      end
    end
  end
end
