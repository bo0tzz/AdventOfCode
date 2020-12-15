defmodule Day15_2 do
  def test(input) do
    starting_ns = String.split(input, ",") |> Enum.map(&String.to_integer/1) |> Enum.with_index()

    {latest, _} = last = List.last(starting_ns)

    seen = List.delete(starting_ns, last) |> Map.new()
    i = map_size(seen)
    process(seen, i, latest)
  end

  def process(_, 29999999, latest), do: latest
  def process(seen, i, latest) do
    age = case Map.get(seen, latest) do
      nil -> 0
      last_seen -> i - last_seen
    end
    process(Map.put(seen, latest, i), i + 1, age)
  end
end
