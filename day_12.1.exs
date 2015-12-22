input = Interface.read_input

answer = ~r/-?\d+(?:\.\d+)?/
  |> Regex.scan(input)
  |> Enum.map(fn([number_match]) ->
    {value, ""} = Float.parse(number_match)
    value
  end)
  |> Enum.sum

Interface.print_output(answer)
