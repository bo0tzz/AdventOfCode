defmodule Day12_2 do
  @directions %{
    north: {0, 1},
    south: {0, -1},
    east: {1, 0},
    west: {-1, 0},
  }

  def test(input) do
    Util.lines(input)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(%{pos: {0, 0}, waypoint: {10, 1}}, &process_instruction/2)
    |> manhattan_distance()
  end

  def process_instruction({:forward, amount}, %{pos: pos, waypoint: w} = ship), do: %{ship | pos: move(w, amount, pos)}
  def process_instruction({:right, amount}, %{waypoint: w} = ship), do: %{ship | waypoint: rotate(w, amount)}
  def process_instruction({:left, amount}, %{waypoint: w} = ship), do: %{ship | waypoint: rotate(w, -amount)}
  def process_instruction({dir, amount}, %{waypoint: w} = ship), do: %{ship | waypoint: move(@directions[dir], amount, w)}

  def move({dx, dy}, times, {x, y}), do: {x + (dx * times), y + (dy * times)}

  def rotate({x, y}, 90), do: {y, x * -1}
  def rotate(waypoint, amount) when amount < 0, do: rotate(waypoint, amount + 360)
  def rotate(waypoint, amount), do: rotate(waypoint, amount - 90) |> rotate(90)

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
