defmodule Day11_1 do
  def test(input) do
    parse(input)
    |> run_automata()
    |> List.flatten()
    |> Enum.frequencies()
    |> Map.fetch!(:full)
  end

  def run_automata(grid) do
    new_grid =
      Enum.with_index(grid)
      |> Enum.map(&map_line(grid, &1))

    case new_grid do
      g when g == grid -> g
      _ -> run_automata(new_grid)
    end
  end

  def map_line(grid, {line, y}) do
    Enum.with_index(line)
    |> Enum.map(fn {seat, x} ->
      full_seats =
        surrounding_coords(x, y)
        |> Enum.map(&access(grid, &1))
        |> Enum.frequencies()
        |> Map.get(:full, 0)

      case {seat, full_seats} do
        {:empty, 0} ->
          :full

        {:full, n} when n >= 4 ->
          :empty

        {seat, _} ->
          seat
      end
    end)
  end

  def print(grid) do
    Enum.each(grid, fn row ->
      Enum.each(row, fn seat ->
        case seat do
          :floor -> "."
          :empty -> "L"
          :full -> "#"
        end
        |> IO.write()
      end)

      IO.puts("")
    end)

    grid
  end

  def surrounding_coords(x, y) do
    for(x <- (x - 1)..(x + 1), y <- (y - 1)..(y + 1), do: {x, y})
    |> List.delete({x, y})
  end

  def access(_, {x, y}) when x < 0 or y < 0, do: :empty
  def access(grid, {_, y}) when y >= length(grid), do: :empty

  def access(grid, {x, y}) do
    case Enum.at(grid, y) do
      row when x >= length(row) -> :empty
      row -> Enum.at(row, x)
    end
  end

  def parse(input) do
    Util.lines(input)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    String.trim(line)
    |> String.codepoints()
    |> Enum.map(
      &case &1 do
        "L" -> :empty
        "." -> :floor
      end
    )
  end
end
