module Symm32
  # see family.cr
  # The 4 types of classification + 1 'none' for everything else
  enum AxisKind
    None    # non-axial, non-cubic families have no special classifications
    Axial   # in axial families, isometries in the z axis
    Planar  # in axial families, isometries perp. to the z axis
    OnAxes  # in cubic families, isometries on cubic axes (xyz)
    OffAxes # in cubic families, isometries off cubic axes (everything else)

    def symbol
      case
      when axial?
        "|"
      when planar?
        "_"
      when on_axes?
        "+"
      when off_axes?
        "\\"
      else
        ""
      end
    end
  end
end
