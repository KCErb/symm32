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
end
