input = Interface.read_input

answer = input
  |> String.split("\n")
  |> Enum.filter(fn(string) ->
    Regex.match?(~r/([a-z])([a-z]).*\1\2/, string) &&
    Regex.match?(~r/([a-z]).\1/, string)
  end)
  |> Enum.count

Interface.print_output(answer)
