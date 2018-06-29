require "./symm32/*"

# Module for working with the 32 crystallographic point groups
#
# At the moment, the focus is on their group > subgroup relationships, i.e.
# the 212 non-magnetic species.
module Symm32

  # Returns an array of the 32 crystallographic point groups
  def point_groups
    point_groups = {} of String => Symm32::PointGroup

    symmetry_json = File.read("../crystal-symmetry.json")
    symmetry = JSON.parse(symmetry_json)

    symmetry["crystal-families"].each do |family_name, group|
      group.each do |name, props|
        isometries = [] of String
        props["isometries"].each do |isometry|
          isometries << isometry.as_s
        end
        name_s = name.as_s
        point_groups[name_s] = Symm32::PointGroup.new(family_name.as_s, name_s, isometries)
      end
    end
    return point_groups
  end
end
