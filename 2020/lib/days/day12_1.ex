defmodule Day12_1 do
  @north {0, 1}
  @south {0, -1}
  @east {1, 0}
  @west {-1, 0}

  def test(input) do
    Util.lines(input)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(%{pos: {0, 0}, heading: @east}, &process_instruction/2)
    |> manhattan_distance()
  end

  def process_instruction({:north, amount}, %{pos: pos} = ship), do: %{ship | pos: move(@north, amount, pos)}
  def process_instruction({:south, amount}, %{pos: pos} = ship), do: %{ship | pos: move(@south, amount, pos)}
  def process_instruction({:east, amount}, %{pos: pos} = ship), do: %{ship | pos: move(@east, amount, pos)}
  def process_instruction({:west, amount}, %{pos: pos} = ship), do: %{ship | pos: move(@west, amount, pos)}
  def process_instruction({:forward, amount}, %{pos: pos, heading: h} = ship), do: %{ship | pos: move(h, amount, pos)}
  def process_instruction({:right, amount}, %{heading: h} = ship), do: %{ship | heading: rotate(h, amount)}
  def process_instruction({:left, amount}, %{heading: h} = ship), do: %{ship | heading: rotate(h, -amount)}

  def move({dx, dy}, times, {x, y}), do: {x + (dx * times), y + (dy * times)}

  def rotate(@north, 90), do: @east
  def rotate(@east, 90), do: @south
  def rotate(@south, 90), do: @west
  def rotate(@west, 90), do: @north

  def rotate(heading, amount) when amount < 0, do: rotate(heading, amount + 360)
  def rotate(heading, amount), do: rotate(heading, amount - 90) |> rotate(90)

  def manhattan_distance(%{pos: {x, y}}), do: abs(x) + abs(y)

  def parse_line("N" <> n), do: {:north, int(n)}
  def parse_line("S" <> n), do: {:south, int(n)}
  def parse_line("E" <> n), do: {:east, int(n)}
  def parse_line("W" <> n), do: {:west, int(n)}
  def parse_line("F" <> n), do: {:forward, int(n)}
  def parse_line("L" <> n), do: {:left, int(n)}
  def parse_line("R" <> n), do: {:right, int(n)}

  def int(n), do: String.trim(n) |> String.to_integer()
end
