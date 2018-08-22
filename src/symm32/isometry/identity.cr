module Symm32
  class Identity
    include Isometry

    def initialize
      @kind = IsometryKind::Identity
    end

    def transform(point)
      point
    end
  end

  Isometry::IDENTITY = Identity.new
end
