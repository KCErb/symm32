require "./isometry_kind"

module Symm32
  # This module adds a `@cardinality` attribute (of type `IsometryCardinality`)
  # to including classes. This idea is useful for a "quick and dirty" approach
  # to narrowing the field of candidates for group - subgroup relationships.
  # The reasoning goes essentially like this: if the potential subgroup
  # requires 2 mirror planes but the potential supergroup has only 1, then
  # don't bother with the math of finding an orientation of sub within super
  # this subgroup candidate can be rejected immediately.
  #
  # It turns out that this metric of a group come in handy elsewhere as well
  # but that's just a useful side effect.
  module Cardinality(T)
    # Number of each kind of isometry:
    #
    # ```
    # {IsometryKind::Identity => 1, IsometryKind::Rotation2 => 3}
    # ```
    #
    # (The above is the "isometry cardinality" of group 222)
    alias IsometryCardinality = Hash(IsometryKind, UInt8)

    # ditto
    getter cardinality = IsometryCardinality.new

    # Simple wrapper for `#self.compute_cardinality` for object initialization.
    def init_cardinality
      Cardinality.compute_cardinality(@isometries)
    end

    # Same as `#self.count_fits` except self is passed in as first argument.
    def count_fits(other : T)
      Cardinality.count_fits(self.cardinality, other.cardinality)
    end

    # Is other a "subset" of self (in terms of cardinality)?
    #
    # Subset, in this case, is defined such that for each isometry kind
    # in self, other has at least as many as self.
    def fits_within?(other : T)
      cardinality.all? do |kind, count|
        other.cardinality[kind]? && other.cardinality[kind] >= count
      end
    end

    # CLASS METHODS

    # Turn an array of `Isometry` into an `IsometryCardinality`
    def self.compute_cardinality(isometries : Set(Isometry))
      by_kind = isometries.group_by { |iso| iso.kind }
      by_kind.map { |k, v| {k, v.size.to_u8} }.to_h
    end

    # Same as `#self.count_fits` except we take as argument an
    # array of `T` rather than just 1 instance.
    def self.count_fits_arr(child_arr : Array(T), parent_arr : Array(T))
      child_card = compute_cardinality_arr(child_arr)
      parent_card = compute_cardinality_arr(parent_arr)
      count_fits(child_card, parent_card)
    end

    # Counts number of ways that child can fit into the parent.
    #
    # This is determined by using the smallest number when dividing parent count
    # by child count for each kind. i.e. it is, based on cardinality alone,
    # the maximum number of fits where all of the child isometries get a
    # different element in the parent.
    def self.count_fits(child_card : IsometryCardinality, parent_card : IsometryCardinality)
      return 1_u8 if child_card.empty?
      counts = child_card.compact_map do |kind, count|
        next if kind == IsometryKind::Identity || kind == IsometryKind::Inversion
        if parent_card[kind]? && parent_card[kind] >= count
          parent_card[kind] / count
        else
          return 0_u8
        end
      end
      counts.sort!
      counts.size > 0 ? counts[0] : 0_u8
    end

    private def self.compute_cardinality_arr(other_arr : Array(T))
      empty = Set(Isometry).new
      all_isometries = other_arr.reduce(empty) do |acc, other|
        acc | other.isometries
      end
      compute_cardinality(all_isometries)
    end
  end
end
