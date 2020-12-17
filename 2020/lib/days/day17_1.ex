defmodule Day17_1 do
  def test(input) do
    parse_initial_state(input)
    |> cycle_count(6)
    |> Map.values()
    |> Enum.filter(&match?(:active, &1))
    |> Enum.count()
  end

  def cycle_count(state, 0), do: state

  def cycle_count(state, n) do
    cycle(state) |> cycle_count(n - 1)
  end

  def cycle(state) do
    Map.keys(state)
    |> all_neighbours()
    |> Enum.reduce(%{}, fn cube, new_state ->
      active_neighbours =
        neighbours(cube)
        |> Enum.map(&get_cube_state(&1, state))
        |> Enum.count(&match?(:active, &1))

      cube_state =
        case active_neighbours do
          3 -> :active
          2 -> get_cube_state(cube, state)
          _ -> :inactive
        end

      Map.put(new_state, cube, cube_state)
    end)
  end

  def all_neighbours(locations) do
    for l <- locations do
      neighbours_keep_original(l)
    end
    |> List.flatten()
    |> Enum.uniq()
  end

  def get_cube_state(location, state) do
    Map.get(state, location, :inactive)
  end

  def neighbours({_x, _y, _z} = n) do
    neighbours_keep_original(n)
    |> List.delete(n)
  end

  def neighbours_keep_original({x, y, z}) do
    for x <- neighbours(x), y <- neighbours(y), z <- neighbours(z) do
      {x, y, z}
    end
  end

  def neighbours(n) do
    (n - 1)..(n + 1)
  end

  def parse_initial_state(state) do
    Util.lines(state)
    |> Enum.with_index()
    |> Enum.map(fn {line, y} ->
      String.trim(line)
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.map(fn {c, x} ->
        case c do
          "." -> {{x, y, 0}, :inactive}
          "#" -> {{x, y, 0}, :active}
        end
      end)
    end)
    |> List.flatten()
    |> Map.new()
  end
end
