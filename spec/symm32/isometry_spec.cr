require "./spec_helper"

module Symm32
  describe Isometry do
    it "can be included" do
      vec = Vector3.new(0, 0, 0)
      point = TestPoint.new(vec)
      res = TestIsometry.new(3).transform(point)
      ans_vec = Vector3.new(0, 0, 3)
      ans = TestPoint.new(ans_vec)
      res.should eq ans
    end
  end

  describe "Isometry#parse" do
    it "creates from string" do
      # simple
      iso = Isometry.parse("mz").as Mirror
      iso.axis.should eq Axis::Z
      iso.kind.should eq IsometryKind::Mirror

      # complex
      iso = Isometry.parse("-3d4^2").as ImproperRotation
      iso.axis.should eq Axis::D4
      iso.kind.should eq IsometryKind::ImproperRotation3_2
    end

    # not sure if this is a bug or a feature at the moment...
    it "is created from a valid (though not crystallographic) string" do
      iso = Isometry.parse("3z").as Rotation
      iso.axis.should eq Axis::Z
      iso.kind.should eq IsometryKind::Rotation3
    end

    it "is not created from an invalid string (general)" do
      expect_raises(ArgumentError) do
        iso = Isometry.parse("foos")
      end
    end
  end
end
