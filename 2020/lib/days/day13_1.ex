defmodule Day13_1 do
  def test(input) do
    [timestamp, buses] = Util.lines(input)
    timestamp = String.trim(timestamp) |> String.to_integer()
    {bus, min_until_departure} = String.split(buses, ",")
    |> Enum.filter(&(&1 != "x"))
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(&with_min_until_departure(&1, timestamp))
    |> Enum.sort(fn {_, m}, {_, n} -> m <= n end)
    |> hd()
    bus * min_until_departure
  end

  def with_min_until_departure(bus, currtime) do
    min = Integer.mod(currtime, bus)
    {bus, bus - min}
  end
end
