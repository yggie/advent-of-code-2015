c("lib/interface.ex")
input = Interface.read_input

{_, map} = input
  |> String.to_char_list
  |> Enum.reduce({{{0, 0}, {0, 0}}, %{ {0, 0} => 2 }}, fn(char, {{{x, y}, next_coord}, map}) ->
    coord = case char do
      ?> -> {x + 1, y}
      ?^ -> {x, y + 1}
      ?< -> {x - 1, y}
      ?v -> {x, y - 1}
      _ -> nil
    end

    if coord == nil do
      {{next_coord, {x, y}}, map}
    else
      {{next_coord, coord}, Map.put(map, coord, Map.get(map, coord, 0))}
    end
  end)

answer = map |> Map.keys |> Enum.count

Interface.print_output(answer)
