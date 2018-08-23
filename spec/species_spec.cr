require "./spec_helper"

module Symm32
  # smoke test
  describe SPECIES do
    it "'s an array constant with 212 members'" do
      SPECIES.size.should eq 212
    end
  end

  describe Species do
    it "has a number" do
      SPECIES[0].number.should eq 1
    end

    it "has a name" do
      SPECIES[0].name.should eq "1. 1b > 1"
    end
  end
end
