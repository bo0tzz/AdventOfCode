defmodule Day2_1 do
  @line_re ~r/(\d+)-(\d+) (\w): (\w+)/

  def test(input) do
    Util.lines(input)
    |> Enum.map(&parse_line/1)
    |> Enum.filter(&is_valid/1)
    |> Enum.count()
  end

  defp parse_line(line) do
    Regex.run(@line_re, line, capture: :all_but_first)
  end

  defp is_valid([min, max, char, password]) do
    {min, _} = Integer.parse(min)
    {max, _} = Integer.parse(max)
    password
    |> String.codepoints()
    |> Enum.filter(&(&1 == char))
    |> Enum.count()
    |> in_bounds(min, max)
  end

  defp in_bounds(count, min, max) do
    min <= count and count <= max
  end
end
