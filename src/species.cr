require "./symm32"
require "./species/**"

# Add "Species" to symm32 module
module Symm32
  struct Species
    getter name : String
    getter number : Int32
    getter orientation : Orientation

    # simple unique name generation
    # ex: 145. 6/mmm > 1
    #
    # Child will have either 1 or 2 symbols appended to name
    # to show how it is oriented first in the z, then in the plane
    # with respect to the parent's classification scheme.
    #
    # Planar orientation only matters to cubic parents, so it is
    # omitted otherwise.
    #
    # ex: 58. 4/mmm > 2/m|
    #     59. 4/mmm > 2/m_
    #     146. 23 > 3\
    #     147. 23 > 222++
    def initialize(@number, @orientation)
      @name = "#{number}. #{parent.name} > #{orientation.child_name}"
    end

    def child
      orientation.child
    end

    def parent
      orientation.parent
    end

    # number of orientational domain states
    def n_domain
      parent.isometries.size / child.isometries.size
    end

    # array of child directions where the axis has been changed
    # to the parent's axis
    def reoriented_child
      orientation.correspondence.map do |child_dir, parent_dir|
        Direction.new(parent_dir.axis, child_dir.isometries)
      end
    end
  end

  SPECIES = [] of Species
  species_counter = 0

  POINT_GROUPS.each do |parent|
    POINT_GROUPS.reverse_each do |child|
      next if parent.name == child.name
      factory = OrientationFactory.new(child, parent)
      orientations = factory.calculate_orientations
      orientations.each do |orient|
        species_counter += 1
        SPECIES << Species.new(species_counter, orient)
      end
    end
  end

  def self.species(num : Int32)
    SPECIES.select { |species| species.number == num }.first
  end

  def self.species_for(parent)
    SPECIES.select { |species| species.parent == parent }
  end
end
