input = case System.argv do
  ["--file", filename] -> File.read!(filename)
  [input] -> input
  _ -> raise "Invalid input"
end

{_, map} = input
  |> String.to_char_list
  |> Enum.reduce({{0, 0}, %{}}, fn(char, {{x, y}, map}) ->
    coord = case char do
      ?> -> {x + 1, y}
      ?^ -> {x, y + 1}
      ?< -> {x - 1, y}
      ?v -> {x, y - 1}
      _ -> nil
    end

    if coord == nil do
      {{x, y}, map}
    else
      {coord, Map.put(map, coord, Map.get(map, coord, 0))}
    end
  end)

answer = map |> Map.keys |> Enum.count

IO.puts(answer)
