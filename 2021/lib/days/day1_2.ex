defmodule Day1_2 do
  def test(input) do
    {_, sums} = Util.lines(input)
    |> Enum.map(&Util.parse_int/1)
    |> windowed_sums()

    {count, _} = sums
    |> Enum.drop(2) |> IO.inspect()
    |> Enum.reduce({0, :first}, &process/2)
    count
  end

  def process(element, {0, :first}), do: {0, element}
  def process(element, {count, previous}) when element > previous, do: {count + 1, element}
  def process(element, {count, _}), do: {count, element}

  def windowed_sums(elements) do
    Enum.reduce(elements, {[0, 0], []}, &windowed_sum/2)
  end

  def windowed_sum(element, {wip, sums}) do
    [new_sum | wip] = Enum.map(wip, &(&1 + element))
    {wip ++ [element], sums ++ [new_sum]}
  end
end
