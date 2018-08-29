require "./cardinality"

module Symm32
  # Store array of isometries in a "direction" which is the combined idea
  # of isometry and axis.
  class Direction
    include Cardinality(Direction)

    getter axis : Axis
    getter kinds : Set(IsometryKind)
    getter isometries : Array(Isometry)
    property classification : AxisKind

    def initialize(@axis, @isometries)
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
