module Symm32
  class Inversion
    include Isometry

    def initialize
      @kind = IsometryKind::Inversion
    end

    def transform(point : Vector3)
      -point
    end
  end

  Isometry::INVERSION = Inversion.new
end
