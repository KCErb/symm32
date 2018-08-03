require "json"
require "./symm32/*"

# Module for working with the 32 crystallographic point groups
#
# At the moment, the focus is on their group > subgroup relationships, i.e.
# the 212 non-magnetic species.
module Symm32
  CRYSTAL_FAMILIES = init_crystal_families
  POINT_GROUPS     = fetch_point_groups

  def self.init_crystal_families
    crystal_families_json = File.read("#{__DIR__}/crystal-families.json")
    crystal_families = Array(CrystalFamily).from_json(crystal_families_json)
    # set backwards relationship so each point group knows its family
    crystal_families.each do |fam|
      fam.point_groups.each { |pg| pg.family = fam }
    end
    crystal_families
  end

  def self.fetch_point_groups
    point_groups = Hash(String, PointGroup).new
    CRYSTAL_FAMILIES.each do |fam|
      fam.point_groups.each { |pg| point_groups[pg.name] = pg }
    end
    return point_groups
  end
end
