module Symm32
  module Cardinality
    # Isometry Cardinality: hash of number of each kind of isometry
    # {IsometryKind::Identity => 1, IsometryKind::Rotation2 => 3} # 222
    alias IsometryCardinality = Hash(IsometryKind, UInt8)
    alias IsometryArr = Array(Isometry)
    getter cardinality : IsometryCardinality

    # uses included class's isometry array by default
    private def compute_cardinality
      return compute_cardinality(@isometries)
    end

    # create an IsometryCardinality (hash) from an Array of Isometry Arrays
    private def compute_cardinality(iso_arr : IsometryArr)
      by_kind = iso_arr.group_by { |iso| iso.kind }
      by_kind.map { |k, v| {k, v.size.to_u8} }.to_h
    end

    # use included class's cardinality by default
    private def has_min_cardinality?(parent_cardinality : IsometryCardinality)
      has_min_cardinality(cardinality, parent_cardinality)
    end

    private def has_min_cardinality?(child_cardinality, parent_cardinality)
      child_cardinality.all? do |kind, count|
        parent_cardinality[kind] && parent_cardinality[kind] >= count
      end
    end

    private def cardinality_match?(other_cardinality : IsometryCardinality)
      cardinality.all? do |kind, count|
        other_cardinality[kind] && other_cardinality[kind] == count
      end
    end
  end
end
