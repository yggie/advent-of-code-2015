input = Interface.read_input

defmodule InfiniteSequence do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def next_number do
    GenServer.call(__MODULE__, :next_number)
  end

  def init(:ok) do
    {:ok, 1}
  end

  def handle_call(:next_number, _from, number) do
    {:reply, number, number + 1}
  end
end

{:ok, _pid} = InfiniteSequence.start_link

check_md5 = fn
  ("00000" <> _rest) ->
    true

  (_anything_else) ->
    false
end

compute_md5 = fn(string) ->
  :crypto.hash(:md5, input <> string) |> Base.encode16(case: :lower)
end

check_value = fn(value) ->
  value |> to_string |> compute_md5.() |> check_md5.()
end

answer = Stream.repeatedly(&InfiniteSequence.next_number/0) |> Enum.find(&check_value.(&1))

Interface.print_output(answer)
