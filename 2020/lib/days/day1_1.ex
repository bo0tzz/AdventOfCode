defmodule Day1_1 do
  def test(input) do
    lines = Util.lines(input) |> Enum.map(&Integer.parse/1)
    {_, x, y} = Enum.map(lines, fn ({x, _}) -> Enum.map(lines, fn ({y, _}) -> {x + y, x, y} end) end)
    |> List.flatten
    |> Enum.find(fn {sum, _, _} -> sum == 2020 end)
    x * y
  end
end
