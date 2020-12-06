defmodule Day6_2 do
  @empty_line_regex ~r/(\n|\r\n){2}/m

  def test(input) do
    Regex.split(@empty_line_regex, input, trim: true)
    |> Enum.map(&parse_group/1)
    |> Enum.sum()
  end

  def parse_group(group) do
    Util.lines(group)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&mapset_from_chars/1)
    |> Enum.reduce(&MapSet.intersection/2)
    |> MapSet.size()
  end

  def mapset_from_chars(chars) do
    String.codepoints(chars)
    |> MapSet.new()
  end
end
