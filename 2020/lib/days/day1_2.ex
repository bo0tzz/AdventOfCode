defmodule Day1_2 do
  def test(input) do
    lines = Util.lines(input) |> Enum.map(&Integer.parse/1)
    Enum.map(lines, fn ({x, _}) -> Enum.map(lines, fn ({y, _}) -> Enum.map(lines, fn ({z, _}) -> {x + y + z, x, y, z} end) end) end)
    |> List.flatten
    |> Enum.find(fn {sum, _, _, _} -> sum == 2020 end)
    |> (fn ({_, x, y, z}) -> x * y * z end).()
  end
end
