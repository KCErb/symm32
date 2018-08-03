require "spec"
require "../src/symm32"

def orientations_count(child_name, parent_name)
  Symm32::POINT_GROUPS[child_name].orientations_within(Symm32::POINT_GROUPS[parent_name]).size
end
