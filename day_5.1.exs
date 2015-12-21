input = Interface.read_input

answer = input
  |> String.split("\n")
  |> Enum.filter(fn(string) ->
    Enum.count(Regex.scan(~r/[aeiou]/, string)) >= 3 &&
    Regex.match?(~r/([a-z])\1/, string) &&
    !Regex.match?(~r/(ab|cd|pq|xy)/, string)
  end)
  |> Enum.count

Interface.print_output(answer)
