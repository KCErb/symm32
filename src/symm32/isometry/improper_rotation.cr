module Symm32
  class ImproperRotation
    include Isometry
    include CompoundIsometry
    getter axis

    def initialize(@axis : Axis, n_fold : Int32, power = 1)
      kind_enum = "ImproperRotation#{n_fold}"
      kind_enum += "_#{power}" unless power == 1
      @kind = IsometryKind.parse(kind_enum)
      @isometries = Set(Isometry).new
      @isometries << Rotation.new(@axis, n_fold, power)
      @isometries << Isometry::INVERSION
    end
  end
end
