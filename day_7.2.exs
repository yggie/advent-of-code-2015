input = Interface.read_input

defmodule BitwiseLogicGatesLazyInterpreter do
  use Bitwise

  @assignment_regex ~r/^([\w\s]+)\s+->\s+(\w+)$/
  @compute_regex ~r/^(\w+)\s+(\w+)\s+(\w+)$/
  @unary_not_regex ~r/^NOT\s+(\w+)$/

  def lazy_eval(string, context \\ %{}) do
    peval(string, :lazy, context)
  end

  def eval(string, context \\ %{}) do
    peval(string, :not_lazy, context)
  end

  def peval(string, eval_type, context) do
    string
    |> String.split("\n")
    |> Enum.reduce({0, context}, fn(expression, {_prev_result, new_context}) ->
      eval_expression(eval_type, expression, new_context)
    end)
  end

  defp eval_expression(:lazy, expression, context) do
    case Regex.run(~r/^([\w\s]+)\s+->\s+(\w+)$/, expression) do
      [_match, compute_expression, variable] ->
        eval_assignment_expression(:lazy, compute_expression, variable, context)

      nil ->
        {expression, context}
    end
  end

  defp eval_expression(:not_lazy, expression, context) do
    cond do
       Regex.match?(@assignment_regex, expression) ->
         [_match, lhs, rhs] = Regex.run(@assignment_regex, expression)
         eval_assignment_expression(:not_lazy, lhs, rhs, context)

      Regex.match?(@compute_regex, expression) ->
        [_match, receiver, op, arg] = Regex.run(@compute_regex, expression)
        {receiver, context} = eval_item(receiver, context)
        {arg, context} = eval_item(arg, context)
        {eval_compute_expression({op, [receiver, arg]}), context}

      Regex.match?(@unary_not_regex, expression) ->
        [_match, variable] = Regex.run(@unary_not_regex, expression)
        {variable, context} = eval_item(variable, context)
        {eval_compute_expression({"NOT", [variable]}), context}

      expression == "" ->
        {nil, context}

      true ->
        eval_item(expression, context)
    end
  end

  defp eval_assignment_expression(eval_type, lhs, rhs, context) do
    {result, context} = eval_expression(eval_type, lhs, context)
    assign(eval_type, rhs, result, context)
  end

  defp eval_compute_expression({"NOT", [value]}) do
    bnot(value)
  end

  defp eval_compute_expression({"OR", [left, right]}) do
    bor(left, right)
  end

  defp eval_compute_expression({"AND", [left, right]}) do
    band(left, right)
  end

  defp eval_compute_expression({"LSHIFT", [left, right]}) do
    bsl(left, right)
  end

  defp eval_compute_expression({"RSHIFT", [left, right]}) do
    bsr(left, right)
  end

  defp eval_compute_expression({op, _receiver, _arg}) do
    raise "Unexpected token: #{op} in compute expression"
  end

  defp eval_item(variable, context) do
    case Integer.parse(variable) do
      {integer, ""} ->
        {integer, context}

      _otherwise ->
        case Map.fetch(context, variable) do
          {:ok, {:lazy, expression}} ->
            eval_assignment_expression(:not_lazy, expression, variable, context)

          {:ok, value} ->
            {value, context}

          _otherwise ->
            raise "Undefined variable: #{variable}"
        end
    end
  end

  defp assign(:lazy, variable, lazy_expression, context) do
    {lazy_expression, Map.put(context, variable, {:lazy, lazy_expression})}
  end

  defp assign(:not_lazy, variable, result, context) do
    {result, Map.put(context, variable, result)}
  end
end

{_result, context} = input |> BitwiseLogicGatesLazyInterpreter.lazy_eval
{a_value, _discarded_context} = BitwiseLogicGatesLazyInterpreter.eval("a", context)

{_result, context} = BitwiseLogicGatesLazyInterpreter.lazy_eval("#{a_value} -> b", context)
{answer, _context} = BitwiseLogicGatesLazyInterpreter.eval("a", context)

Interface.print_output(answer)
