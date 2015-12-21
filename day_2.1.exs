input = Interface.read_input

answer = input
  |> String.split("\n")
  |> Enum.map(fn(line) -> line |> String.split("x") end)
  |> Enum.reduce(0, fn
    ([box_length, box_width, box_height], area_so_far) ->
      {box_length, _} = Integer.parse(box_length)
      {box_width, _} = Integer.parse(box_width)
      {box_height, _} = Integer.parse(box_height)

      area_0 = box_length * box_width
      area_1 = box_height * box_width
      area_2 = box_length * box_height

      area_so_far + 2*area_0 + 2*area_1 + 2*area_2 + Enum.min([area_0, area_1, area_2])

    ([""], area_so_far) -> area_so_far
  end)

Interface.print_output(answer)
