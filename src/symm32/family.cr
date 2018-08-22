module Symm32
  # The primary purpose of this class is to classify isometries
  # in a group according to the summit of the family, for example
  # in the tetragonal group, we can classify the 2-fold axis
  # of group 4 as 2-axial because in 4/mmm there is also
  # 2-planar. This is important for species distinctions.
  enum Family
    Triclinic
    Monoclinic
    Orthorhombic
    Tetragonal
    Hexagonal
    Cubic

    # see note in README, this is hard-coded with prior knowledge instead of generalized
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
