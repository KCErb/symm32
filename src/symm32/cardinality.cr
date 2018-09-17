require "./isometry_kind"

module Symm32
  module Cardinality(T)
    # Isometry Cardinality: hash of number of each kind of isometry
    # {IsometryKind::Identity => 1, IsometryKind::Rotation2 => 3} # 222
    alias IsometryCardinality = Hash(IsometryKind, UInt8)
    getter cardinality : IsometryCardinality
    @cardinality = IsometryCardinality.new

    # create an IsometryCardinality (hash) from an Array of Isometries
    def init_cardinality
      Cardinality.compute_cardinality(@isometries)
    end

    def count_fits(other : T)
      Cardinality.count_fits(self.cardinality, other.cardinality)
    end

    # Does other have a greater or equal cardinality for all isometries? If so
    # then self "fits within" other.
    def fits_within?(other : T)
      cardinality.all? do |kind, count|
        other.cardinality[kind]? && other.cardinality[kind] >= count
      end
    end

    # CLASS METHODS
    # these take two arguments so we treat them as module methods
    # not sure about this pattern to be honest ...
    def self.compute_cardinality(isometries : Array(Isometry))
      by_kind = isometries.group_by { |iso| iso.kind }
      by_kind.map { |k, v| {k, v.size.to_u8} }.to_h
    end

    # child fits within parent? - next three methods all for this one
    def self.count_fits_arr(child_arr : Array(T), parent_arr : Array(T))
      child_card = compute_cardinality_arr(child_arr)
      parent_card = compute_cardinality_arr(parent_arr)
      count_fits(child_card, parent_card)
    end

    # Counts number of ways that child can fit into the parent
    # This is determined by ignoring the None fit and then using the smallest
    # number when dividing parent/child for each kind. i.e. it is the max fit where all
    # of child get a different element in parent
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
      all_isometries = other_arr.flat_map(&.isometries)
      compute_cardinality(all_isometries)
    end
  end
end
