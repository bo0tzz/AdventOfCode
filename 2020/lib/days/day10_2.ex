defmodule Day10_2 do
  use Memoize

  def test(input) do
    Util.lines(input)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort()
    |> add_ends()
    |> count_valid_solutions()
  end

  def add_ends(adapters), do: [0 | adapters] ++ [List.last(adapters) + 3]

  defmemo count_valid_solutions([first, second]) when (second - first) <= 3, do: 1
  defmemo count_valid_solutions([first, second]) when (second - first) > 3, do: 0
  defmemo count_valid_solutions([first, second | _]) when (second - first) > 3, do: 0
  defmemo count_valid_solutions([first, second | rest]), do: count_valid_solutions([first | rest]) + count_valid_solutions([second | rest])
end
