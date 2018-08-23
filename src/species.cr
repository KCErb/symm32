require "./symm32"
require "./species/**"

# Add "species" to symm32 module
module Symm32
  struct Species
    def initialize(@number : Int32, @name : String, @orientation : Orientation)
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
        name = "#{species_counter}. #{parent.name} > #{child.name}"
        SPECIES << Species.new(species_counter, name, orient)
      end
    end
  end

  # module
end
