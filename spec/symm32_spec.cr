require "./spec_helper"

module Symm32
  # smoke tests
  describe POINT_GROUPS do
    it "'s an array constant with 32 members'" do
      POINT_GROUPS.size.should eq 32
    end

    it "can find individuals by name" do
      Symm32.point_group("222").should eq POINT_GROUPS[5]
    end
  end
end
