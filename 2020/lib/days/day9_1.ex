defmodule Day9_1 do
  def test(input) do
    input = Util.lines(input)
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(&(elem(&1, 0)))
    buf = Enum.take(input, 25)
    input = Enum.drop(input, 25)
    find_invalid(buf, input)
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
