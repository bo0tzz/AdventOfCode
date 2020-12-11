defmodule Day11_2 do
  def test(input) do
    parse(input)
    |> add_visible_seats()
    |> run_automata()
    |> List.flatten()
    |> Enum.map(fn {type, _} -> type end)
    |> Enum.frequencies()
    |> Map.fetch!(:full)
  end

  def add_visible_seats(grid) do
    Enum.with_index(grid)
    |> Enum.map(fn {line, y} ->
      Enum.with_index(line)
      |> Enum.map(fn {seat, x} ->
        {seat, visible_seats(grid, x, y)}
      end)
    end)
  end

  def visible_seats(grid, x, y) do
    surrounding_coords(x, y)
    |> Enum.map(&visible_seats(grid, &1))
  end

  def visible_seats(grid, {{x, y} = at, {dx, dy} = d}) do
    case access(grid, at) do
      :floor -> visible_seats(grid, {{x + dx, y + dy}, d})
      _ -> at
    end
  end

  def run_automata(grid) do
    new_grid = Enum.map(grid, &map_line(grid, &1))

    case new_grid do
      ^grid -> grid
      _ -> run_automata(new_grid)
    end
  end

  def map_line(grid, line) do
    Enum.map(line, fn {seat, visible} = s ->
      full_seats =
        visible
        |> Enum.map(&access(grid, &1))
        |> Enum.frequencies()
        |> Map.get(:full, 0)

      case {seat, full_seats} do
        {:empty, 0} ->
          {:full, visible}

        {:full, n} when n >= 5 ->
          {:empty, visible}

        {_, _} ->
          s
      end
    end)
  end

  def surrounding_coords(x, y) do
    for(dx <- -1..+1, dy <- -1..+1, do: {{x + dx, y + dy}, {dx, dy}})
    |> List.delete({{x, y}, {0, 0}})
  end

  def access(_, {x, y}) when x < 0 or y < 0, do: :empty
  def access(grid, {_, y}) when y >= length(grid), do: :empty

  def access(grid, {x, y}) do
    case Enum.at(grid, y) do
      row when x >= length(row) ->
        :empty

      row ->
        case Enum.at(row, x) do
          {s, _} -> s
          s -> s
        end
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
