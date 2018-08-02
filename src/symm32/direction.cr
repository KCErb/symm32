require "./cardinality"

module Symm32
  # Store array of isometries in a "direction" which is the combined idea
  # of isometry and axis.
  class Direction
    include Cardinality(Direction)

    getter axis : Axis
    getter flag : IsometryKind
    property isometries : Array(Isometry)
    property classification : CrystalFamily::Classification

    def initialize(@axis, @isometries)
      @cardinality = init_cardinality
      kinds = @isometries.map(&.kind)
      @flag = kinds.reduce { |flag, kind| flag | kind } # @flag = kind | kind | kind
      # compiler needs default values since we can't init this one
      @classification = CrystalFamily::Classification::None
    end

    def clone
      copy = self.class.new(axis, isometries)
      copy.classification = classification
      copy
    end
  end
end
