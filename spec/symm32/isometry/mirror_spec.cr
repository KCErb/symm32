require "../spec_helper"

module Symm32
  describe Mirror do
    it "mirrors through given axis" do
      m = Mirror.new(Axis::D1)
      res = m.transform(Vector3.new(1, 1, 1))
      # should be eq. not close to ... but rounding seems unreliable
      # https://github.com/crystal-lang/crystal/issues/3103
      res.close_to?(Vector3.new(-1, -1, -1)).should be_true
    end
  end
end
