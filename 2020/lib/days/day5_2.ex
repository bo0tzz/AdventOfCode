defmodule Day5_2 do
  def test(input) do
    Util.lines(input)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_seat/1)
    |> Enum.map(&seat_id/1)
    |> Enum.sort()
    |> find_missing()
  end

  def find_missing([head | rest]), do: find_missing(rest, head)

  def find_missing([head | rest], current) do
    case head - current do
      1 -> find_missing(rest, head)
      2 -> head - 1
    end
  end

  def seat_id({row, column}), do: (row * 8) + column

  def parse_seat(<<row::binary-size(7), column::binary-size(3)>>) do
    {parse_row(row), parse_column(column)}
  end

  def parse_row(row), do: binary_parse(row, ["F", "B"])
  def parse_column(column), do: binary_parse(column, ["L", "R"])

  def binary_parse(value, characters) do
    String.codepoints(value)
    |> Enum.map(fn c -> Enum.find_index(characters, &(&1 == c)) end)
    |> Enum.map(&Kernel.to_string/1)
    |> Kernel.to_string()
    |> Integer.parse(2)
    |> elem(0)
  end
end
