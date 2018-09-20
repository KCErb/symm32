require "./cardinality"

module Symm32
  # Store array of isometries in a "direction".
  #
  # The `Direction` object, therefore, is a container for understanding
  # all isometries on the same axis. The family's axis classification goes
  # here (see `AxisKind`) as `#classification`, and a `Set` is created
  # which keeps all of the `IsometryKind`s on this axis (`#kinds`).
  class Direction
    include Cardinality(Direction)

    getter axis : Axis
    getter kinds : Set(IsometryKind)
    getter isometries = Set(Isometry).new
    property classification : AxisKind

    def initialize(@axis, isometries_arr)
      isometries_arr.each { |iso| @isometries << iso }
      @cardinality = init_cardinality
      @kinds = @isometries.map(&.kind).to_set
      # compiler needs default values since we can't init this one
      @classification = AxisKind::None
    end

    def clone
      copy = self.class.new(axis, isometries)
      copy.classification = classification
      copy
    end
  end
end
