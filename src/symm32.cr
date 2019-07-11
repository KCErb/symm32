require "symm_base"
require "./*"

# Module / namespace for working with the 32 crystallographic point groups.
module Symm32
  VERSION = "2.0.0"

  # Find a particular point group in the `POINT_GROUPS` array by name.
  #
  # The names used here are nearly Hermann-Mauguin, except that "bar" is given as a
  # lower-case `b`. Thus point group "4 bar" (or "bar 4" depending on your dialect) will
  # be given by `Symm32.point_group("4b")`. Division or "over" is given by a forward
  # slash so that point group "2 over m" is given by `Symm32.point_group("2/m")`.
  #
  # A complete list of the strings used here to identify the point groups can be determined
  # by looking at the `POINT_GROUPS` array.
  def self.point_group(name)
    standard_name = standardize(name)
    POINT_GROUPS.find { |group| group.name == standard_name }.not_nil!
  end

  # Convert a point group name to one of the 32 used here. For example, we use "2mm" instead
  # "mm2" in the `POINT_GROUPS` array so this method is used within `#point_group` to reduce
  # friction. If there are variants we've missed, this is the place to add support for them.
  def self.standardize(name : String)
    if STANDARD_NAMES.includes?(name)
      standard_name = name
    else
      standard_name = NON_STANDARD_NAMES[name]?
      raise "Non-standard name `#{name}` could not be standardized." unless standard_name
    end
    standard_name
  end

  # :nodoc:
  NON_STANDARD_NAMES = {
    "mm2"  => "2mm",
    "m2m"  => "2mm",
    "4bm2" => "4b2m",
    "6b2m" => "6bm2",
  }

  # Array of the 32 crystallographic point groups. Use this array to guarantee
  # object identity when comparing point groups and to iterate over them.
  POINT_GROUPS =
    [
      PointGroup.parse("triclinic", "1", ["e"]),
      PointGroup.parse("triclinic", "1b", ["e", "i"]),
      PointGroup.parse("monoclinic", "2", ["e", "2z"]),
      PointGroup.parse("monoclinic", "m", ["e", "mz"]),
      PointGroup.parse("monoclinic", "2/m", ["e", "2z", "i", "mz"]),
      PointGroup.parse("orthorhombic", "222", ["e", "2z", "2t0", "2t90"]),
      PointGroup.parse("orthorhombic", "2mm", ["e", "2z", "mt0", "mt90"]),
      PointGroup.parse("orthorhombic", "mmm", ["e", "2z", "2t0", "2t90", "i", "mz", "mt0", "mt90"]),
      PointGroup.parse("tetragonal", "4", ["e", "4z", "2z", "4z^3"]),
      PointGroup.parse("tetragonal", "4b", ["e", "-4z", "2z", "-4z^3"]),
      PointGroup.parse("tetragonal", "4/m", ["e", "4z", "2z", "4z^3", "i", "-4z", "mz", "-4z^3"]),
      PointGroup.parse("tetragonal", "422", ["e", "4z", "2z", "4z^3", "2t0", "2t45", "2t90", "2t135"]),
      PointGroup.parse("tetragonal", "4mm", ["e", "4z", "2z", "4z^3", "mt0", "mt45", "mt90", "mt135"]),
      PointGroup.parse("tetragonal", "4b2m", ["e", "-4z", "2z", "-4z^3", "2t0", "2t90", "mt45", "mt135"]),
      PointGroup.parse("tetragonal", "4/mmm",
        [
          "e", "4z", "2z", "4z^3", "2t0", "2t45", "2t90", "2t135",
          "i", "-4z", "mz", "-4z^3", "mt0", "mt45", "mt90", "mt135",
        ]
      ),
      PointGroup.parse("hexagonal", "3", ["e", "3z", "3z^2"]),
      PointGroup.parse("hexagonal", "3b", ["e", "3z", "3z^2", "i", "-3z", "-3z^2"]),
      PointGroup.parse("hexagonal", "32", ["e", "3z", "3z^2", "2t30", "2t90", "2t150"]),
      PointGroup.parse("hexagonal", "3m", ["e", "3z", "3z^2", "mt0", "mt60", "mt120"]),
      PointGroup.parse("hexagonal", "3bm",
        [
          "e", "3z", "3z^2", "2t0", "2t60", "2t120",
          "i", "-3z", "-3z^2", "mt0", "mt60", "mt120",
        ]
      ),
      PointGroup.parse("hexagonal", "6", ["e", "6z", "3z", "2z", "3z^2", "6z^5"]),
      PointGroup.parse("hexagonal", "6b", ["e", "3z", "3z^2", "-6z", "mz", "-6z^5"]),
      PointGroup.parse("hexagonal", "6/m",
        [
          "e", "6z", "3z", "2z", "3z^2", "6z^5",
          "i", "-6z", "-3z", "mz", "-3z^2", "-6z^5",
        ]
      ),
      PointGroup.parse("hexagonal", "622",
        [
          "e", "6z", "3z", "2z", "3z^2", "6z^5",
          "2t0", "2t30", "2t60", "2t90", "2t120", "2t150",
        ]
      ),
      PointGroup.parse("hexagonal", "6mm",
        [
          "e", "6z", "3z", "2z", "3z^2", "6z^5",
          "mt0", "mt30", "mt60", "mt90", "mt120", "mt150",
        ]
      ),
      PointGroup.parse("hexagonal", "6bm2",
        [
          "e", "3z", "3z^2", "2t30", "2t90", "2t150",
          "-6z", "mz", "-6z^5", "mt0", "mt60", "mt120",
        ]
      ),
      PointGroup.parse("hexagonal", "6/mmm",
        [
          "e", "6z", "3z", "2z", "3z^2", "6z^5",
          "i", "-6z", "-3z", "mz", "-3z^2", "-6z^5",
          "2t0", "2t30", "2t60", "2t90", "2t120", "2t150",
          "mt0", "mt30", "mt60", "mt90", "mt120", "mt150",
        ]
      ),
      PointGroup.parse("cubic", "23",
        [
          "e", "2t0", "2t90", "2z",
          "3d1", "3d1^2", "3d2", "3d2^2",
          "3d3", "3d3^2", "3d4", "3d4^2",
        ]
      ),
      PointGroup.parse("cubic", "m3b",
        [
          "e", "2t0", "2t90", "2z",
          "i", "mt0", "mt90", "mz",
          "3d1", "3d1^2", "-3d1", "-3d1^2",
          "3d2", "3d2^2", "-3d2", "-3d2^2",
          "3d3", "3d3^2", "-3d3", "-3d3^2",
          "3d4", "3d4^2", "-3d4", "-3d4^2",
        ]
      ),
      PointGroup.parse("cubic", "432",
        [
          "e", "2t0", "2t90", "2z",
          "4t0", "4t0^3", "4t90", "4t90^3", "4z", "4z^3",
          "2e1", "2t45", "2e2", "2t135", "2e3", "2e4",
          "3d1", "3d1^2", "3d2", "3d2^2",
          "3d3", "3d3^2", "3d4", "3d4^2",
        ]
      ),
      PointGroup.parse("cubic", "4b3m",
        [
          "e", "-4z", "2z", "-4z^3",
          "-4t0", "2t0", "-4t0^3", "-4t90", "2t90", "-4t90^3",
          "3d1", "3d1^2", "3d2", "3d2^2",
          "3d3", "3d3^2", "3d4", "3d4^2",
          "me1", "mt45", "me2", "mt135", "me3", "me4",
        ]
      ),
      PointGroup.parse("cubic", "m3bm",
        [
          "e", "2t0", "2t90", "2z", "i", "mt0", "mt90", "mz",
          "3d1", "3d1^2", "-3d1", "-3d1^2", "3d2", "3d2^2", "-3d2", "-3d2^2",
          "3d3", "3d3^2", "-3d3", "-3d3^2", "3d4", "3d4^2", "-3d4", "-3d4^2",
          "4t0", "4t0^3", "4t90", "4t90^3", "4z", "4z^3",
          "-4t0^3", "-4t0", "-4t90^3", "-4t90", "-4z^3", "-4z",
          "2e1", "2t45", "2e2", "2t135", "2e3", "2e4",
          "me1", "mt45", "me2", "mt135", "me3", "me4",
        ]
      ),
    ]

  # An array of the strings used to identify the point groups in `POINT_GROUPS`.
  STANDARD_NAMES = POINT_GROUPS.map(&.name)
end
