input = hd(System.argv)

answer = input |> String.to_char_list |> Enum.reduce(0, fn
  (?(, total) -> total + 1
  (?), total) -> total - 1
end)

IO.puts("The answer is: #{answer}")
