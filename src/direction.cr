module Symm32
  # Store array of isometries in a "direction".
  #
  # The `Direction` object, therefore, is a container for understanding
  # all isometries on the same axis. The family's axis classification goes
  # here (see `AxisKind`) as `#classification`.
  #
  # Also stores a `Set` of `Isometry#kind` symbols which turns out to be
  # a mathematically useful thing to know about a direction.
  class Direction
    getter axis : Axis
    getter kinds : Set(Symbol)
    getter isometries = Set(Isometry).new
    property classification : AxisKind

    def initialize(@axis, isometries_arr)
      isometries_arr.each { |iso| @isometries << iso }
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
