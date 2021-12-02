defmodule Day2_1 do
  def test(input) do
    {x, y} = Util.lines(input)
    |> Enum.map(&parse_line/1)
    |> Enum.reduce({0, 0}, &move/2)

    x * y
  end

  def move({"forward", amount}, {x, y}), do: {x + amount, y}
  def move({"down", amount}, {x, y}), do: {x, y + amount}
  def move({"up", amount}, {x, y}), do: {x, y - amount}

  def parse_line(line) do
    [direction, amount] = String.split(line, " ")
    {direction, Util.parse_int(amount)}
  end
end
