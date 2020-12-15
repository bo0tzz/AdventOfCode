defmodule Day15_2 do
  def test(input) do
    starting_ns = String.split(input, ",") |> Enum.map(&String.to_integer/1) |> Enum.with_index()

    {latest, _} = last = List.last(starting_ns)

    seen = List.delete(starting_ns, last) |> Map.new()
    i = map_size(seen)
    ets = :ets.new(:day15_seen, [:set])
    Enum.each(seen, fn s ->
      :ets.insert(ets, s)
    end)
    process(ets, i, latest)
  end

  def process(_, 29999999, latest), do: latest
  def process(seen, i, latest) do
    age = case :ets.lookup(seen, latest) do
      [] -> 0
      [{_, last_seen}] -> i - last_seen
    end
    :ets.insert(seen, {latest, i})
    process(seen, i + 1, age)
  end
end
