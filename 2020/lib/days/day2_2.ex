defmodule Day2_2 do
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
    case {String.at(password, min - 1), String.at(password, max - 1)} do
      {a, b} when a == b -> false
      {a, _} when a == char -> true
      {_, b} when b == char -> true
      _ -> false
    end
  end
end
