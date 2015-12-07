input = case System.argv do
  ["--file", filename] -> File.read!(filename)
  [input] -> input
  _ -> raise "Invalid input"
end

answer = input |> String.to_char_list |> Enum.reduce(0, fn
  (?(, total) -> total + 1
  (?), total) -> total - 1
end)

IO.puts(answer)
