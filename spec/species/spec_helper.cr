require "../spec_helper"

def orientations_count(child, parent)
  child = Symm32.point_group(child)
  parent = Symm32.point_group(parent)

  factory = Symm32::OrientationFactory.new(child, parent)
  orientations = factory.calculate_orientations
  orientations.size
end
