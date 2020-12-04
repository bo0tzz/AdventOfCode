defmodule Day4_1 do
  @empty_line_regex ~r/^$/m
  @required_fields ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

  def test(input) do
    String.split(input, @empty_line_regex)
    |> Enum.map(&is_valid/1)
    |> Enum.count(&(&1))
  end

  def is_valid(passport) do
    Enum.all?(@required_fields, &(String.contains?(passport, &1)))
  end
end
