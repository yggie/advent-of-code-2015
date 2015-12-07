input = case System.argv do
  ["--file", filename] -> File.read!(filename)
  [input] -> input
  _ -> raise "Invalid input"
end

{-1, answer} = input
  |> String.to_char_list
  |> Enum.with_index
  |> Enum.reduce({0, 0}, fn
    (_, {-1, answer}) -> {-1, answer}
    ({?(, index}, {level, _}) -> {level + 1, index}
    ({?), index}, {level, _}) -> {level - 1, index}
  end)

IO.puts("The answer is: #{answer + 1}")
