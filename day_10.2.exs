input = Interface.read_input

defmodule LookAndSaySequence do
  def apply(sequence) do
    build_sequence(sequence)
  end

  defp build_sequence(sequence) do
    build_sequence(sequence, [])
  end

  defp build_sequence("", list_so_far) do
    list_so_far |> Enum.reverse |> Enum.join("")
  end

  defp build_sequence(<<char>> <> rest_of_sequence, list_so_far) do
    {count, remaining_sequence} = count_matches(char, rest_of_sequence, 1)

    build_sequence(remaining_sequence, [<<char>>, to_string(count) | list_so_far])
  end

  defp count_matches(char, <<char>> <> rest_of_sequence, count_so_far) do
    count_matches(char, rest_of_sequence, count_so_far + 1)
  end

  defp count_matches(_char, rest_of_sequence, count_so_far) do
    {count_so_far, rest_of_sequence}
  end
end

answer = 1..50
  |> Enum.reduce(input, fn(_index, sequence) ->
    LookAndSaySequence.apply(sequence)
  end)
  |> String.length

Interface.print_output(answer)
