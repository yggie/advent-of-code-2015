input = Interface.read_input

defmodule SantasPasswordGenerator do
  def generate(old_password) do
    increment(old_password |> Enum.reverse) |> Enum.reverse
  end

  defp increment([?z | rest]) do
    [?a | increment(rest)]
  end

  defp increment([char | rest]) do
    [char + 1 | rest]
  end
end

defmodule SecurityElfPolicy do
  def validate_password(password) do
    scan_password(password, %{})
  end

  defp scan_password([?i | _rest], _results) do
    false
  end

  defp scan_password([?o | _rest], _results) do
    false
  end

  defp scan_password([?l | _rest], _results) do
    false
  end

  defp scan_password([], results) do
    repeated_chars = Map.get(results, "repeated_chars", HashSet.new)
    has_straight = Map.get(results, "has_straight", false)

    HashSet.size(repeated_chars) >= 2 && has_straight
  end

  defp scan_password([char, char | rest], results) do
    repeated_chars = Map.get(results, "repeated_chars", HashSet.new)
    scan_password([char | rest], Map.put(results, "repeated_chars", HashSet.put(repeated_chars, char)))
  end

  defp scan_password([char, next_char, next_next_char | rest], results) do
    if char + 1 == next_char and next_char + 1 == next_next_char do
      results = Map.put(results, "has_straight", true)
    end

    scan_password([next_char, next_next_char | rest], results)
  end

  defp scan_password([_char | rest], results) do
    scan_password(rest, results)
  end
end

answer = input
  |> String.to_char_list
  |> Stream.unfold(fn(old_password) ->
    new_password = SantasPasswordGenerator.generate(old_password)
    {new_password, new_password}
  end)
  |> Enum.find(&SecurityElfPolicy.validate_password/1)

Interface.print_output(answer)
