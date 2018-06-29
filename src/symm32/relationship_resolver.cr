module Symm32
  module RelationshipResolver
    extend self

    # determine if group_a is a subgroup of group_b
    def subgroup?(group_a, group_b)
      # exit(0) if group_b.name == "4b3m"
      return true if simple_subgroup?(group_a, group_b)
      return false unless cardinality_ok?(group_a, group_b)
      subgroups = resolve_subgroups(group_a, group_b, false)
      subgroups.size > 0
    end

    # determine if group_a is a supergroup of group_b
    def supergroup?(group_a, group_b)
      subgroup?(group_b, group_a)
    end

    private def simple_subgroup?(group_a, group_b)
      intersection = group_a.isometry_names & group_b.isometry_names
      intersection.sort == group_a.isometry_names.sort
    end

    # check to see if group has at least as many mirror planes, rotations axes
    # etc as the subgroup requires
    private def cardinality_ok?(group_a, group_b)
      group_b.cardinality_ok?(group_a)
    end

    # Count the number of ways that group_a can fit into group_b
    # check jumps out early on a cardinality check, if you've already
    # performed that check then it's wasteful to do it again so
    # you can pass in false to save a few cycles
    def resolve_subgroups(group_a, group_b, check=true)
      results = [] of Array(Isometry)
      return results if check && !cardinality_ok?(group_a, group_b)
      combinations = init_combinations(group_a, group_b)

      # iterate through all combinations of isometries in positions
      # and save the ones that meet the group's requirements
      subgroup = combinations.map { |col| col[0]  }
      # Array(Isometry).new(combinations.size, combinations[0][0]) # init array
      recursive_permutations(subgroup, 0, combinations, group_a, results)
      return results
    end

    # init subgroups array with combinations of isometries of group b
    # ex: if group a is mm2 then combinations will contain
    # [
    #   [2, 2, 2, 2],
    #   [ [m,m], [m,m], etc ]
    # ]
    # where the nested array of arrays gives each of the combinations
    def init_combinations(group_a, group_b)
      combinations = [] of Array(Isometry) | Array(Array(Isometry))

      group_a.cardinality.each do |kind, count|
        iso_of_kind = group_b.isometries.select { |i| i.kind === kind }
        if count == 1
          combinations << iso_of_kind
        else
          combinations << iso_of_kind.combinations(count)
        end
      end
      return combinations
    end

    # This recursive method iterates through an array of arrays where the inner arrays
    # are of variable size. It generates all possible combinations of 1D arrays drawing
    # each column from the respective column in the 2D array.
    def recursive_permutations(arr, indx, thing, group_a, results)
      thing[indx].each do |elem|
        arr[indx] = elem
        if (indx+1 < thing.size)
          recursive_permutations(arr, indx+1, thing, group_a, results)
        else
          # YIELD -
          # except we can't with recursive functions because they are inline so the logic goes here
          results << arr.flatten if group_a.equiv(arr.flatten, false)
        end
      end
    end

  end
end
