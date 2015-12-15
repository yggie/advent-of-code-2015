input = case System.argv do
  ["--file", filename] -> File.read!(filename)
  [input] -> input
  _ -> raise "Invalid input"
end

defmodule Diff do
  def compute("", total) do
    total
  end

  def compute("\\\\" <> rest, total) do
    Diff.compute(rest, total + 1)
  end

  def compute("\\\"" <> rest, total) do
    Diff.compute(rest, total + 1)
  end

  def compute("\\x" <> rest, total) do
    if Regex.match?(~r/^[\da-f]{2}/, rest) do
      <<_, _>> <> new_rest = rest
      Diff.compute(new_rest, total + 3)
    else
      Diff.compute(rest, total)
    end
  end

  def compute(<<_>> <> rest, total) do
    Diff.compute(rest, total)
  end
end

diff = input
  |> String.split("\n")
  |> Enum.reduce(-2, fn(line, diff) ->
    diff + Diff.compute(line, 2)
  end)

IO.puts(diff)
