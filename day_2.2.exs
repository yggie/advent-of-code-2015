input = Interface.read_input

answer = input
  |> String.split("\n")
  |> Enum.map(fn(line) -> line |> String.split("x") end)
  |> Enum.reduce(0, fn
    ([box_length, box_width, box_height], ribbon_used) ->
      {box_length, _} = Integer.parse(box_length)
      {box_width, _} = Integer.parse(box_width)
      {box_height, _} = Integer.parse(box_height)

      volume = box_height * box_width * box_length

      perimeter_plus_extra = 2*box_width + 2*box_length + 2*box_height

      ribbon_used + volume + perimeter_plus_extra - 2*Enum.max([box_length, box_width, box_height])

    ([""], area_so_far) -> area_so_far
  end)

Interface.print_output(answer)
