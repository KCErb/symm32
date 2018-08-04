module Symm32
  # The primary purpose of this class is to classify isometries
  # in a group according to the summit of the family, for example
  # in the tetragonal group, we can classify the 2-fold axis
  # of group 4 as 2-axial because in 4/mmm there is also
  # 2-planar. This is important for species distinctions
  class CrystalFamily
    # The 4 types of classification + 1 'none' for everything else
    enum Classification : UInt8
      None    # many isometries have no special classification
      Axial   # in axial families, isometries in the z axis
      Planar  # in axial families, isometries perp. to the z axis
      OnAxes  # in cubic families, isometries on cubic axes (xyz)
      OffAxes # in cubic families, isometries off cubic axes (everything else)
    end

    JSON.mapping(
      name: {type: String, setter: false},
      point_groups: {type: Array(PointGroup), setter: false}
    )

    # have to do this hacky, dummy initialize due to this issue:
    # https://stackoverflow.com/questions/51282839/51300113
    def initialize
      @name = "dummy"
      @point_groups = [] of PointGroup
    end

    # see note in README, this is hard-coded with prior knowledge instead of generalized
    def classify_directions(point_group : PointGroup)
      if (name == "tetragonal" || name == "hexagonal")
        classify_axial(point_group.directions)
      elsif (name == "cubic")
        classify_cubic(point_group.directions)
      end
      # don't classify otherwise, they start off as None and that's correct
      # for the remaining cases
    end

    # # This one is especially special, since mm2 is the only member
    # # which is "axial" in this particular sense, it can distinguish
    # # it's 2-fold axis from the plane that holds the mirrors (normals).
    # private def classify_orthorhombic(directions, name)
    #   return unless name == "mm2"
    #   classify_axial(directions)
    # end

    private def classify_axial(directions)
      directions.each do |dir|
        next dir.classification = Classification::None if dir.axis.none?
        is_axial = dir.axis.z?
        dir.classification = is_axial ? Classification::Axial : Classification::Planar
      end
    end

    private def classify_cubic(directions)
      directions.each do |dir|
        next dir.classification = Classification::None if dir.axis.none?
        on = [Axis::Z, Axis::T0, Axis::T90].includes?(dir.axis)
        dir.classification = on ? Classification::OnAxes : Classification::OffAxes
      end
    end
  end
end
