module Symm32
  class PointGroup
    property family_name : String
    property name : String
    property isometries
    getter requirements
    # Cardinality: hash of number of each kind of isometry
    # {IsometryKind::Mirror: 3, IsometryKind::Rotation: 1, etc.}
    getter cardinality : Hash(IsometryKind, Int8)

    # Create new point group object from array of isometry strings
    # the format of these strings is important and specified in isometry.cr
    def initialize(@family_name, @name, isometry_arr)
      @isometries = [] of Isometry
      isometry_arr.each do |isometry_name|
        @isometries << Isometry.new(isometry_name)
      end
      @requirements = Requirements.new(@isometries)
      @cardinality = init_cardinality
    end

    # isometries as simple strings instead of objects
    def isometry_names
      isometries.map { |i| i.name  }
    end

    # Determine if this group is a subgroup of the one passed in
    def subgroup?(parent_group : PointGroup)
      RelationshipResolver.subgroup?(self, parent_group)
    end

    # Determine if this group is a super of the one passed in
    def supergroup?(child_group : PointGroup)
      RelationshipResolver.supergroup?(self, child_group)
    end

    # Determine if the passed in array of isometries
    # meets the requirements of the group.
    def ==(subgroup : Array(Isometry))
      equiv(subgroup)
    end

    # Number and names of species where other is a subgroup of self
    # Returns Hash of count, for example
    # [self is 4/mmm] species("mm2")
    # {"mm2|" => 2, "mm2_" => 4} etc
    def species(other : PointGroup)
      res = {} of String => Int32
      subgroups = RelationshipResolver.resolve_subgroups(other, self)
      species_arr = subgroups.map { |sub| subgroup_to_species(sub, other) } # [mm2|, mm2|, mm2_, mm2_, mm2_, mm2_]
      species_arr.group_by { |e| e }.map { |k, v|  res[k] = v.size }
      return res
    end

    # non-binary equivalence operator, let's you decide if you want to
    # do the cardinality check. Internal methods sometimes do it earlier
    # so it may be wasteful to do it again.
    def equiv(subgroup : Array(Isometry), check=true)
      return false if check && !cardinality_ok?(subgroup)
      return false if subgroup.uniq.size != subgroup.size # no dupes
      own_names = @isometries.map { |i| i.name }
      needs_checked = subgroup.reject { |iso| iso.inverse? || iso.identity? } # cardinality covers these
      @requirements.meets?(needs_checked)
    end

    # Other point group can be a subgroup of this group
    # based on cardinality of kinds alone. i.e. it must
    # have the right number of each kind
    def cardinality_ok?(other : PointGroup)
      cardinality_ok?(other.isometries)
    end

    # Determine name of "subspecies" this subgroup would be based on
    # relation to the group.
    private def subgroup_to_species(subgroup, other)
      # First lets just think of axial groups. So in the parent group we have z and in the subgroup
      # we'll have the z elements still in z or not. So we return the name of the subgroup with a | or _ to indicate
      axis_elements = subgroup.select(&.axis?)
      meets? = other.requirements.axis_requirement.met_by?(axis_elements)
      meets? ? other.name + "|" : other.name + "_"
    end

    private def cardinality_ok?(other : Array(Isometry))
      own_kinds = [] of String
      @isometries.map do |i|
        count = own_kinds.count{ |kind| kind[0].to_s == i.kind }
        own_kinds <<  i.kind + count.to_s
      end

      other_kinds = [] of String
      other.map do |i|
        count = other_kinds.count{ |kind| kind[0].to_s == i.kind }
        other_kinds <<  i.kind + count.to_s
      end
      (other_kinds - own_kinds).empty?
    end

    private def init_cardinality
      by_kind = @isometries.group_by { |iso| iso.kind }
      return by_kind.map { |k, v| [k, v.size] }
    end
  end
end
