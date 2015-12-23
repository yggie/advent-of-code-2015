input = Interface.read_input

defmodule HappinessLookup do
  def parse(string) do
    matches = Regex.scan(~r/(\w+) would (gain|lose) (\d+) happiness units by sitting next to (\w+)\./, string)

    Enum.reduce(matches, {%{}, HashSet.new}, fn([_full_match, person_a, lose_or_gain, happiness, person_b], {lookup, people})->
      key = make_key(person_a, person_b)
      happiness_change = Map.get(lookup, key, 0) + parse_happiness(lose_or_gain, happiness)

      {Map.put(lookup, key, happiness_change), HashSet.put(HashSet.put(people, person_a), person_b)}
    end)
  end

  defp parse_happiness("gain", happiness) do
    {value, ""} = Integer.parse(happiness)
    value
  end

  defp parse_happiness("lose", happiness) do
    {value, ""} = Integer.parse(happiness)
    -value
  end

  def make_key(person_a, person_b) do
    [person_a, person_b] |> Enum.sort |> List.to_tuple
  end
end

defmodule CyclicGraphSearch do
  def maximize_traversal_cost({lookup, nodes}) do
    nodes |> Enum.reduce({[], -1_000_000_000}, fn(first_node, best_so_far) ->
      remaining_nodes = HashSet.delete(nodes, first_node)
      search(remaining_nodes, first_node, lookup, {[first_node], 0}, best_so_far)
    end)
  end

  defp search_guarded(remaining_nodes, current_node, lookup, {path_so_far, cost_so_far}, {best_path, best_cost}) do
    if HashSet.size(remaining_nodes) == 0 do
      key = HappinessLookup.make_key(current_node, List.last(path_so_far))
      cost = cost_so_far + Map.get(lookup, key, 0)

      if cost > best_cost do
        {path_so_far, cost}
      else
        {best_path, best_cost}
      end
    else
      search(remaining_nodes, current_node, lookup, {path_so_far, cost_so_far}, {best_path, best_cost})
    end
  end

  defp search(remaining_nodes, current_node, lookup, {path_so_far, cost_so_far}, best_so_far) do
    remaining_nodes |> Enum.reduce(best_so_far, fn(next_node, current_best) ->
      next_remaining_nodes = HashSet.delete(remaining_nodes, next_node)
      key = HappinessLookup.make_key(current_node, next_node)
      next_cost = Map.get(lookup, key, 0) + cost_so_far

      search_guarded(next_remaining_nodes, next_node, lookup, {[next_node | path_so_far], next_cost}, current_best)
    end)
  end
end

add_myself = fn({lookup, people})->
  {lookup, HashSet.put(people, "Me, Myself and I")}
end

{_reverse_path, answer} = input
  |> HappinessLookup.parse
  |> add_myself.()
  |> CyclicGraphSearch.maximize_traversal_cost

Interface.print_output(answer)
