module Symmetry
  class ImproperRotation < PointIsometry
    include CompoundIsometry

    @isometries = [] of Isometry

    def initialize(axis, angle)
      @isometries << Rotation.new(axis, angle)
      @isometries << PointIsometry::INVERSION
    end

    def initialize(axis, n_fold : Int32, power = 1)
      @isometries << Rotation.new(axis, n_fold, power)
      @isometries << PointIsometry::INVERSION
    end
  end
end
