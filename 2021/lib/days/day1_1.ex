defmodule Day1_1 do
  def test(input) do
    {count, _} = Util.lines(input)
    |> Enum.map(&Util.parse_int/1)
    |> Enum.reduce({0, :first}, &process/2)
    count
  end

  def process(element, {0, :first}), do: {0, element}
  def process(element, {count, previous}) when element > previous, do: {count + 1, element}
  def process(element, {count, _}), do: {count, element}
end
