input = case System.argv do
  ["--file", filename] -> File.read!(filename)
  [input] -> input
  _ -> raise "Invalid input"
end

answer = input
  |> String.split("\n")
  |> Enum.filter(fn(string) ->
    Regex.match?(~r/([a-z])([a-z]).*\1\2/, string) &&
    Regex.match?(~r/([a-z]).\1/, string)
  end)
  |> Enum.count

IO.puts(answer)
