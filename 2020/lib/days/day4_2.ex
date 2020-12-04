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
      [_, value] -> Kernel.apply(Day4_2, String.to_atom(field), [value])
      nil -> false
    end
  end

  def between(value, from, to) do
    {value, _} = Integer.parse(value)
    value >= from and value <= to
  end

  def byr(value), do: between(value, 1920, 2002)

  def iyr(value), do: between(value, 2010, 2020)

  def eyr(value), do: between(value, 2020, 2030)

  def hgt(value) do
    case Regex.run(~r/^(\d+)(in|cm)$/, value) do
      [_, n, "cm"] -> between(n, 150, 193)
      [_, n, "in"] -> between(n, 59, 76)
      _ -> false
    end
  end

  def hcl(value), do: Regex.match?(~r/^#[0-9a-f]{6}$/, value)

  def ecl(value), do: value in @valid_eye_colours

  def pid(value), do: Regex.match?(~r/^\d{9}$/, value)
end
