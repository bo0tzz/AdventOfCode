defmodule Day15_1 do
  def test(input) do
    String.split(input, ",")
    |> Enum.reverse()
    |> Enum.map(&String.to_integer/1)
    |> next_number()
  end

  def next_number([latest | rest]) when length(rest) == 2019, do: latest
  def next_number([latest | rest] = spoken) do
    case Enum.find_index(rest, fn el -> el == latest end) do
      nil -> next_number([0 | spoken])
      age -> next_number([age + 1 | spoken])
    end
  end
end
