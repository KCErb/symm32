require "./spec_helper"

module Symm32
  describe "PointIsometry#parse" do
    it "creates from string" do
      # simple
      iso = PointIsometry.parse("mz").as Mirror
      iso.axis.should eq Axis::Z

      # complex
      iso = PointIsometry.parse("-3d4^2").as ImproperRotation
      iso.axis.should eq Axis::D4
    end

    # not sure if this is a bug or a feature at the moment...
    it "is created from a valid (though not crystallographic) string" do
      iso = PointIsometry.parse("3z").as Rotation
      iso.axis.should eq Axis::Z
    end

    it "is not created from an invalid string (general)" do
      expect_raises(ArgumentError) do
        PointIsometry.parse("foos")
      end
    end
  end
end
