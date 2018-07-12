require "json"
require "./symm32/*"

# Module for working with the 32 crystallographic point groups
#
# At the moment, the focus is on their group > subgroup relationships, i.e.
# the 212 non-magnetic species.
module Symm32
  # Returns an array of the 32 crystallographic point groups
  def self.point_groups
    point_groups_json = File.read("#{__DIR__}/../point-groups.json")
    Array(PointGroup).from_json(point_groups_json)
  end
end
