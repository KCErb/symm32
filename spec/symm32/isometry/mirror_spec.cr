require "../spec_helper"

module Symm32
  describe Mirror do
    it "mirrors through given axis" do
      m = Mirror.new(Axis::D1)
      vec = Vector3.new(1, 1, 1)
      point = TestPoint.new(vec)
      res = m.transform(point)
      ans_vec = Vector3.new(-1, -1, -1)
      ans = TestPoint.new(ans_vec, false)
      res.should eq ans
    end
  end
end
