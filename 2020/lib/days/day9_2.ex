defmodule Day9_2 do
  def test(input) do
    input = Util.lines(input)
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(&(elem(&1, 0)))
    buf = Enum.take(input, 25)
    rest = Enum.drop(input, 25)
    {:invalid, num} = find_invalid(buf, rest)
    find_contiguous_sum(input, num)
  end

  def find_contiguous_sum(input, sum) do
    Enum.reduce_while(input, {:cont, {0, []}}, fn elem, {:cont, {acc, seen}} ->
      case elem + acc do
        ^sum -> {:halt, {:found, {elem, [elem | seen]}}}
        n when n > sum -> {:halt, {:fail, {acc, [elem | seen]}}}
        n -> {:cont, {:cont, {n, [elem | seen]}}}
      end
    end) |> case do
      {:found, {_, seen}} -> Enum.min(seen) + Enum.max(seen)
      {:fail, _} -> tl(input) |> find_contiguous_sum(sum)
    end
  end

  def head_tail([head | enum]) do
    {head, Enum.reverse(enum) |> hd}
  end

  def find_invalid(buf, [top | input]) do
    case contains_sum(buf, top) do
      false -> {:invalid, top}
      true -> ring_add(buf, top) |> find_invalid(input)
    end
  end

  def ring_add([_ | enum], new), do: enum ++ [new]

  def contains_sum(buf, sum) do
    sum in (mesh(buf, buf) |> Enum.map(fn {x, y} -> x + y end))
  end

  def mesh(e1, e2) do
    for e <- e1, f <- e2, do: {e, f}
  end
end
