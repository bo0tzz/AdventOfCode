defmodule Day13_2 do
  def test(input) do
    [_, buses] = Util.lines(input)
    String.split(buses, ",")
    |> Enum.with_index()
    |> Enum.reject(&match?({"x", _}, &1))
    |> Enum.map(fn {n, i} -> {String.to_integer(n), i} end)
    |> find_departure_chain_time()
  end

  def find_departure_chain_time([{first, 0} | rest]), do: find_departure_chain_time(rest, first, first)
  def find_departure_chain_time([{bus, offset} | rest], t, step) do
    t = search(t, offset, step, bus)
    case rest do
      [] -> t
      _ -> find_departure_chain_time(rest, t, step * bus)
    end
  end

  def search(from, offset, step, target) do
    case Integer.mod(from + offset, target) do
      0 -> from
      _ -> search(from + step, offset, step, target)
    end
  end
end
