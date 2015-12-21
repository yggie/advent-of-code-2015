c("lib/interface.ex")
input = Interface.read_input

defmodule LightController do
  def perform_operation("turn on " <> range_string, light_grid) do
    turn_on(light_grid, parse_range(range_string))
  end

  def perform_operation("turn off " <> range_string, light_grid) do
    turn_off(light_grid, parse_range(range_string))
  end

  def perform_operation("toggle " <> range_string, light_grid) do
    toggle(light_grid, parse_range(range_string))
  end

  def perform_operation("", light_grid) do
    light_grid
  end

  defp parse_range(command) do
    matches = Regex.scan(~r/^(\d+),(\d+) through (\d+),(\d+)$/, command)
    [[_string, string_start_x, string_start_y, string_end_x, string_end_y]] = matches
    {start_x, ""} = Integer.parse(string_start_x)
    {start_y, ""} = Integer.parse(string_start_y)
    {end_x, ""} = Integer.parse(string_end_x)
    {end_y, ""} = Integer.parse(string_end_y)

    for i <- start_x..end_x, j <- start_y..end_y do
      i + 1000*j
    end
  end

  defp turn_on(light_grid, range) do
    Enum.reduce(range, light_grid, fn(position, light_grid) ->
      Map.put(light_grid, position, 1)
    end)
  end

  defp turn_off(light_grid, range) do
    Enum.reduce(range, light_grid, fn(position, light_grid) ->
      Map.put(light_grid, position, 0)
    end)
  end

  defp toggle(light_grid, range) do
    Enum.reduce(range, light_grid, fn(position, light_grid) ->
      Map.put(light_grid, position, 1 - Map.get(light_grid, position, 0))
    end)
  end
end

answer = input
  |> String.split("\n")
  |> Enum.reduce(%{}, &LightController.perform_operation/2)
  |> Map.values
  |> Enum.sum

Interface.print_output(answer)
