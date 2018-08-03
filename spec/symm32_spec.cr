require "./spec_helper"

describe Symm32 do
  # smoke tests
  it "has 6 families" do
    Symm32::CRYSTAL_FAMILIES.size.should eq 6
  end

  it "has 32 point groups" do
    Symm32::POINT_GROUPS.size.should eq 32
  end

  it "calculates 212 species" do
    species_count = 0
    reverse_point_groups = Symm32::POINT_GROUPS.to_a.reverse.to_h
    Symm32::POINT_GROUPS.each do |_, parent|
      reverse_point_groups.each do |_, child|
        next if parent.name == child.name
        orientations = child.orientations_within(parent)
        species_count += orientations.size
      end
    end
    species_count.should eq 212
  end
end
