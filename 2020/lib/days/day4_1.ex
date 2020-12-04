defmodule Day4_1 do
  @empty_line_regex ~r/^$/m
  @required_fields ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

  def test(input) do
    String.split(input, @empty_line_regex)
    |> Enum.map(fn data -> Enum.all?(@required_fields, &(String.contains?(data, &1))) end)
    |> Enum.count(&(&1))
  end
end
