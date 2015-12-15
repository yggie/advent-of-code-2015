input = case System.argv do
  ["--file", filename] -> File.read!(filename)
  [input] -> input
  _ -> raise "Invalid input"
end

answer = input
  |> String.split("\n")
  |> Enum.filter(fn(string) ->
    Enum.count(Regex.scan(~r/[aeiou]/, string)) >= 3 &&
    Regex.match?(~r/([a-z])\1/, string) &&
    !Regex.match?(~r/(ab|cd|pq|xy)/, string)
  end)
  |> Enum.count

IO.puts(answer)
