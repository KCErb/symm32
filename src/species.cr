require "./symm32"
require "./species/**"

# Adds "Species" to symm32 module
module Symm32
  # Simple struct for associating a number, name, and orientation.
  struct Species
    # Species name, determined by parent.name and `Orientation#child_name`.
    #
    # Examples
    # ```text
    # 145. 6/mmm > 1
    # 146. 23 > 3\
    # 147. 23 > 222++
    # ```
    getter name : String
    getter number : Int32
    getter orientation : Orientation

    def initialize(@number, @orientation)
      @name = "#{number}. #{parent.name} > #{orientation.child_name}"
    end

    def child
      orientation.child
    end

    def parent
      orientation.parent
    end

    # Number of orientational domain states
    def n_domain
      parent.isometries.size / child.isometries.size
    end

    # Array of child directions where the axis has been changed
    # to the parent's axis.
    def reoriented_child
      orientation.correspondence.map do |child_dir, parent_dir|
        Direction.new(parent_dir.axis, child_dir.isometries)
      end
    end
  end

  SPECIES = [] of Species
  species_counter = 0

  # Calculate the 212 species
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

  # Get species by number
  def self.species(num : Int32)
    SPECIES.select { |species| species.number == num }.first
  end

  # Get species where the parent PointGroup is `parent`.
  def self.species_for(parent : PointGroup)
    SPECIES.select { |species| species.parent == parent }
  end
end
