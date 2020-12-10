defmodule Day10_1 do
  def test(input) do
    Util.lines(input)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort()
    |> Enum.reduce(%{prev: 0, dists: Map.put(%{}, 3, 1)}, &add_difference/2)
    |> calculate_answer()
  end

  def calculate_answer(%{dists: dists}) do
    Map.get(dists, 1) * Map.get(dists, 3)
  end

  def add_difference(current, %{prev: prev, dists: dists}), do: %{
      prev: current,
      dists: Map.update(dists, current - prev, 1, &(&1 + 1))
    }
end
