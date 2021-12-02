defmodule Day2_2 do
  def test(input) do
    {{x, y}, aim} = Util.lines(input)
    |> Enum.map(&parse_line/1)
    |> Enum.reduce({{0, 0}, 0}, &move/2)

    x * y
  end

  def move({"forward", amount}, {{x, y}, aim}), do: {{x + amount, y + (amount * aim)}, aim}
  def move({"down", amount}, {{x, y}, aim}), do: {{x, y}, aim + amount}
  def move({"up", amount}, {{x, y}, aim}), do: {{x, y}, aim - amount}

  def parse_line(line) do
    [direction, amount] = String.split(line, " ")
    {direction, Util.parse_int(amount)}
  end
end
