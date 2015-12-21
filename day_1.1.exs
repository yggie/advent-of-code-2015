c("lib/interface.ex")
input = Interface.read_input

answer = input |> String.to_char_list |> Enum.reduce(0, fn
  (?(, total) -> total + 1
  (?), total) -> total - 1
end)

Interface.print_output(answer)
