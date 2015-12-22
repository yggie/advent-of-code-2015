input = Interface.read_input

check_md5 = fn
  (<<0, 0, 0>> <> _rest) ->
    true

  (_anything_else) ->
    false
end

compute_md5 = fn(string) ->
  :crypto.hash(:md5, input <> string)
end

check_value = fn(value) ->
  value |> to_string |> compute_md5.() |> check_md5.()
end

answer = Stream.unfold(0, fn(acc) -> {acc, acc + 1} end)
  |> Enum.find(&check_value.(&1))

Interface.print_output(answer)
