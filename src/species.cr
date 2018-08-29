require "./symm32"
require "./species/**"

# Add "Species" to symm32 module
module Symm32
  struct Species
    getter name : String
    getter number : Int32
    getter orientation : Orientation

    def initialize(@number, @orientation)
      # Not a proper name, will try to implement that in the future
      @name = "#{number}. #{parent.name} > #{child.name}"
    end

    def child
      orientation.child
    end

    def parent
      orientation.parent
    end

    def n_diff
      parent.isometries.size - child.isometries.size
    end

    # array of child directions where the axis has been changed
    # to the parent's axis
    def reoriented_child
      orientation.map.map do |child_dir, parent_dir|
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

  # get all species where `name` is the name of the child group
  def self.species_for_child(name : String)
    SPECIES.select { |species| species.child.name == name }
  end

  def self.species(num : Int32)
    SPECIES.select { |species| species.number == num }
  end
end
