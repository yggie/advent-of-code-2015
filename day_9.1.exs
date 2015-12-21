input = Interface.read_input

defmodule TravelDiary do
  def put_entry(diary, "") do
    diary
  end

  def put_entry(%{ travel_distance_lookup: travel_distance_lookup, locations: locations }, entry) do
    [_match, start_loc, end_loc, dist] = Regex.run(~r/^(\w+) to (\w+) = (\d+)$/, entry)
    key = make_key(start_loc, end_loc)
    {dist, ""} = Integer.parse(dist)

    %{
      travel_distance_lookup: Map.put(travel_distance_lookup, key, dist),
      locations: HashSet.put(HashSet.put(locations, start_loc), end_loc)
    }
  end

  def travel_distance(diary, start_loc, end_loc) do
    key = make_key(start_loc, end_loc)
    diary.travel_distance_lookup[key]
  end

  defp make_key(start_loc, end_loc) do
    [start_loc, end_loc] |> Enum.sort |> List.to_tuple
  end
end

defmodule GraphSearch do
  def minimize_traversal_cost(nodes, cost_lookup) do
    cost_lookup_list = cost_lookup
      |> Map.to_list
      |> List.keysort(1)

    nodes |> Enum.reduce({[], 1_000_000_000}, fn(first_node, best_so_far) ->
      remaining_nodes = HashSet.delete(nodes, first_node)
      traverse_nodes(remaining_nodes, cost_lookup_list, {[first_node], 0}, best_so_far)
    end)
  end

  defp traverse_nodes_guarded(remaining_nodes, cost_lookup_list, trail_so_far, best_so_far) do
    if HashSet.size(remaining_nodes) == 0 do
      [trail_so_far, best_so_far] |> List.keysort(1) |> hd
    else
      traverse_nodes(remaining_nodes, cost_lookup_list, trail_so_far, best_so_far)
    end
  end

  defp traverse_nodes(remaining_nodes, cost_lookup_list, trail_so_far, best_so_far) do
    {[last_node | list_so_far], cost_so_far} = trail_so_far

    remaining_nodes
    |> Enum.reduce(best_so_far, fn(chosen_node, next_best_so_far) ->
      next_remaining_nodes = HashSet.delete(remaining_nodes, chosen_node)

      {_lookup_key, cost} = cost_lookup_list
        |> Enum.find(fn({{node_0, node_1}, _cost}) ->
          cond do
            {node_0, node_1} == {chosen_node, last_node} || {node_0, node_1} == {last_node, chosen_node} ->
              true

            true ->
              false
          end
        end)

      next_cost = cost_so_far + cost
      traverse_nodes_guarded(next_remaining_nodes, cost_lookup_list, {[chosen_node, last_node | list_so_far], next_cost}, next_best_so_far)
    end)
  end
end

diary = input |> String.split("\n")
  |> Enum.reduce(%{ travel_distance_lookup: %{}, locations: HashSet.new }, fn(entry, diary) ->
    TravelDiary.put_entry(diary, entry)
  end)

{_reverse_trail, answer} = GraphSearch.minimize_traversal_cost(diary.locations, diary.travel_distance_lookup)

Interface.print_output(answer)
