require "./spec_helper"

module Symmetry
  module Crystallographic
    describe POINT_GROUPS do
      it "'s an array constant with 32 members'" do
        POINT_GROUPS.size.should eq 32
      end

      it "can be accessed by a method" do
        Crystallographic.point_groups.should eq POINT_GROUPS
      end

      it "can find individuals by name" do
        Crystallographic.point_group("222").should eq POINT_GROUPS[5]
      end
    end
  end
end
