require "./spec_helper"

module Symm32
  describe OrientationFactory do
    it "can be created" do
      child = Symm32.point_group("222")
      parent = Symm32.point_group("422")
      of = OrientationFactory.new(child, parent)
      of.child.should eq child
      of.parent.should eq parent
    end

    it "returns empty array if child cardinality simply does not fit" do
      child = Symm32.point_group("1b")
      parent = Symm32.point_group("222")

      factory = OrientationFactory.new(child, parent)
      orientations = factory.calculate_orientations
      orientations.size.should eq 0
    end

    it "returns orientation with empty map if child has no z" do
      child = Symm32.point_group("1")
      parent = Symm32.point_group("222")

      factory = OrientationFactory.new(child, parent)
      orientations = factory.calculate_orientations
      orientations.size.should eq 1
      orientations.first.correspondence.empty?.should be_true
    end

    # check some specific cases which have failed in the past
    describe "#calculate_orientations" do
      it "222 fits within 4/mmm once" do
        orientations_count("222", "4/mmm").should eq 1
      end

      it "222 fits within m3b once" do
        orientations_count("222", "m3b").should eq 1
      end

      it "222 fits within 432 twice" do
        orientations_count("222", "432").should eq 2
      end

      it "6 fits within 622 once" do
        orientations_count("6", "622").should eq 1
      end

      it "23 fits within 432 once" do
        orientations_count("23", "432").should eq 1
      end

      it "23 fits within m3bm once" do
        orientations_count("23", "m3bm").should eq 1
      end

      it "4b2m fits within m3bm twice" do
        orientations_count("4b2m", "m3bm").should eq 2
      end

      it "m3b does not fit within 432" do
        orientations_count("m3b", "432").should eq 0
      end

      it "mm2 fits within m3bm thrice" do
        orientations_count("mm2", "m3bm").should eq 3
      end
    end
  end
end
