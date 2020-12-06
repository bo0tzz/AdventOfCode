defmodule Day6_1 do
  @empty_line_regex ~r/(\n|\r\n){2}/m

  def test(input) do
    Regex.split(@empty_line_regex, input, trim: true)
    |> Enum.map(&parse_group/1)
    |> Enum.map(&MapSet.size/1)
    |> Enum.reduce(&(&1 + &2))
  end

  def parse_group(group) do
    Util.lines(group)
    |> Enum.map(&String.trim/1)
    |> Enum.reduce(MapSet.new(), &add_entry/2)
  end

  def add_entry(entry, mapset) do
    String.codepoints(entry)
    |> Enum.reduce(mapset, fn (c, acc) -> MapSet.put(acc, c) end)
  end
end
