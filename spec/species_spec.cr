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

    it "counts number of orientational domains correctly" do
      Symm32.species(155).n_domain.should eq 6
    end

    it "can compute child's directions in parent's orientation" do
      # 4b2m > 2|  so the 2 is the only child dir and in parent it is Z
      species = Symm32.species(45)
      z_dir = species.reoriented_child.first
      z_dir.axis.should eq Axis::Z

      # 4b2m > 2_  so the 2 is the only child dir and in parent it is in T plane
      species = Symm32.species(46)
      z_dir = species.reoriented_child.first
      z_dir.axis.should eq Axis::T0
    end
  end

  describe "#species" do
    it "can get a species by number" do
      species = Symm32.species(32)
      species.number.should eq 32
      species.parent.should eq Symm32.point_group("422")
      species.child.should eq Symm32.point_group("222")
    end
  end
end
