defmodule Day3_1 do
  def test(input) do
    bits = Util.lines(input)
    |> Enum.map(&read_chars/1)
    |> Enum.reduce(&accumulate/2)
    |> Enum.map(&List.flatten/1)
    |> Enum.map(&Enum.frequencies/1)
    |> Enum.map(&most_common/1)
    |> Enum.join()

    {gamma, _} = Integer.parse(bits, 2)
    {epsilon, _} = String.split(bits, "")
    |> invert()
    |> Enum.join()
    |> Integer.parse(2)

    gamma * epsilon
  end

  def read_chars(chars) do
    String.split(chars, "")
    |> Enum.reject(&match?("", &1))
    |> Enum.map(&Util.parse_int/1)
  end

  def accumulate([], []), do: []
  def accumulate([bit | bits], [freq | acc]), do: [[freq] ++ [bit]] ++ accumulate(bits, acc)

  def most_common(%{0 => zero, 1 => one}) when zero > one, do: 0
  def most_common(%{0 => zero, 1 => one}) when one > zero, do: 1

  def invert(bits, _), do: invert(bits)
  def invert([]), do: []
  def invert([bit | bits]), do: [invert(bit)] ++ invert(bits)
  def invert("0"), do: "1"
  def invert("1"), do: "0"
  def invert(""), do: ""
end
