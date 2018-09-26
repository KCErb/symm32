module Symm32
  # The 4 types of axis classification + 'None' for everything else.
  #
  # Tetragonal and Hexagonal families have axial symmetry. Each isometry
  # has an axis. Thus, members of these point groups can classify these
  # axes (see `Axis`) or there `#directions` as either being `Axial`
  # meaning parallel to that axis, or planar, meaning perpendicular to it.
  #
  # Likewise, the Cubic family groups can classify their axes as either
  # being `OnAxes` meaning the axis passes through a face (on the cubic
  # xyz axes) or `OffAxes` meaning they pass through something else
  # like a diagonal or an edge.
  #
  # See also `Family`.
  enum AxisKind
    None
    Axial
    Planar
    OnAxes
    OffAxes

    # Returns a string representing this classification
    #
    # ```
    # AxisKind::Axial   # => |
    # AxisKind::Planar  # => _
    # AxisKind::OnAxes  # => +
    # AxisKind::OffAxes # => \
    # ```
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
