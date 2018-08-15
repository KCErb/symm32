module Symmetry
  module Crystallographic
    # The 4 types of classification + 1 'none' for everything else
    enum AxisKind
      None    # non-axial, non-cubic families have no special classifications
      Axial   # in axial families, isometries in the z axis
      Planar  # in axial families, isometries perp. to the z axis
      OnAxes  # in cubic families, isometries on cubic axes (xyz)
      OffAxes # in cubic families, isometries off cubic axes (everything else)
    end

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
end
