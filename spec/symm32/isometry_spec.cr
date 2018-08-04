require "../spec_helper"

module Symm32
  describe Isometry do
    it "is created from a valid string" do
      # simple
      iso = Isometry.from_json(%("mz"))
      iso.axis.should eq Axis::Z
      iso.kind.should eq IsometryKind::Mirror

      # complex
      iso = Isometry.from_json(%("-3d4^2"))
      iso.axis.should eq Axis::D4
      iso.kind.should eq IsometryKind::ImproperRotation3_2
    end

    it "is created from a valid (though not crystallographic) string" do
      iso = Isometry.from_json(%("3z"))
      iso.axis.should eq Axis::Z
      iso.kind.should eq IsometryKind::Rotation3
    end

    it "is not created from an invalid string (no kind)" do
      expect_raises(Exception, "not able to determine kind") do
        iso = Isometry.from_json(%("z"))
      end
    end

    it "is not created from an invalid string (general)" do
      expect_raises(ArgumentError) do
        iso = Isometry.from_json(%("foos"))
      end
    end
  end
end
