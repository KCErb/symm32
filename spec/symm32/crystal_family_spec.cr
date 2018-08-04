require "../spec_helper"

module Symm32
  describe CrystalFamily do
    it "defaults classification to none" do
      bar = make_family("bar")
      bar.point_groups.each { |pg| pg.family = bar }
      none = CrystalFamily::Classification::None
      bar.point_groups[0].directions.map(&.classification).should eq [none, none, none]
      bar.point_groups[1].directions.map(&.classification).should eq [none, none, none]
    end

    it "classifies tetragonal families appropriately" do
      tetragonal = make_family("tetragonal")
      tetragonal.point_groups.each { |pg| pg.family = tetragonal }
      none = CrystalFamily::Classification::None
      axial = CrystalFamily::Classification::Axial
      planar = CrystalFamily::Classification::Planar
      tetragonal.point_groups[0].directions.map(&.classification).should eq [none, axial, planar]
      tetragonal.point_groups[1].directions.map(&.classification).should eq [none, axial, planar]
    end

    it "classifies hexagonal families appropriately" do
      hexagonal = make_family("hexagonal")
      hexagonal.point_groups.each { |pg| pg.family = hexagonal }
      none = CrystalFamily::Classification::None
      axial = CrystalFamily::Classification::Axial
      planar = CrystalFamily::Classification::Planar
      hexagonal.point_groups[0].directions.map(&.classification).should eq [none, axial, planar]
      hexagonal.point_groups[1].directions.map(&.classification).should eq [none, axial, planar]
    end

    it "classifies cubic families appropriately" do
      cubic = make_family("cubic")
      cubic.point_groups.each { |pg| pg.family = cubic }
      none = CrystalFamily::Classification::None
      on = CrystalFamily::Classification::OnAxes
      off = CrystalFamily::Classification::OffAxes
      cubic.point_groups[0].directions.map(&.classification).should eq [none, on, on]
      cubic.point_groups[1].directions.map(&.classification).should eq [none, on, off]
    end
  end
end
