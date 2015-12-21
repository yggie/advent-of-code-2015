defmodule Interface do
  def read_input do
    case System.argv do
      ["--file", filename] -> File.read!(filename)
      [input] -> input
      _ -> raise "Invalid input"
    end
  end

  def print_output(output) do
    IO.puts(output)
  end
end
