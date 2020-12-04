defmodule Day4_2 do
  @empty_line_regex ~r/^$/m
  @required_fields ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
  @valid_eye_colours ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

  def test(input) do
    String.split(input, @empty_line_regex)
    |> Enum.map(&is_valid/1)
    |> Enum.count(&(&1))
  end

  def is_valid(passport) do
    Enum.all?(@required_fields, &(validate_field(&1, passport)))
  end

  def validate_field(field, passport) do
    case Regex.run(~r/#{field}:(\S+)/, passport) do
      [_, value] -> validate(field, value)
      nil -> false
    end
  end

  def int(value) do
    {value, _} = Integer.parse(value)
    value
  end

  def validate("byr", value), do: int(value) in 1920..2002
  def validate("iyr", value), do: int(value) in 2010..2020
  def validate("eyr", value), do: int(value) in 2020..2030
  def validate("ecl", value), do: value in @valid_eye_colours
  def validate("hcl", value), do: Regex.match?(~r/^#[0-9a-f]{6}$/, value)
  def validate("pid", value), do: Regex.match?(~r/^\d{9}$/, value)
  def validate("hgt", value) do
    case Regex.run(~r/^(\d+)(in|cm)$/, value) do
      [_, n, "cm"] -> int(n) in 150..193
      [_, n, "in"] -> int(n) in 59..76
      _ -> false
    end
  end

end
