require "spec"
require "../src/symm32"

ISO0 = Symm32::Isometry.new(Symm32::IsometryKind::Identity, Symm32::Axis::None)
ISO1 = Symm32::Isometry.new(Symm32::IsometryKind::Mirror, Symm32::Axis::Z)
ISO2 = Symm32::Isometry.new(Symm32::IsometryKind::Mirror, Symm32::Axis::T90)
ISO3 = Symm32::Isometry.new(Symm32::IsometryKind::Rotation2, Symm32::Axis::T0)
ISO4 = Symm32::Isometry.new(Symm32::IsometryKind::Rotation2, Symm32::Axis::Z)

ISOMETRIES1 = [ISO0, ISO1, ISO2, ISO3, ISO4]
ISOMETRIES2 = [ISO0, ISO1, ISO3]
ISOMETRIES3 = [ISO0, ISO2, ISO4]

def orientations_count(child_name, parent_name)
  Symm32::POINT_GROUPS[child_name].orientations_within(Symm32::POINT_GROUPS[parent_name]).size
end

def make_family(name)
  Symm32::CrystalFamily.from_json(%({"name": "#{name}",
    "point_groups": [
      { "name": "axial-planar",
        "isometries": ["e", "mz", "2t0"]
      },
      { "name": "on-off",
        "isometries": ["e", "mz", "3d2"]
      }
    ]}))
end
