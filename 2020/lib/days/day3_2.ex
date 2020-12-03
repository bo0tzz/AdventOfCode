defmodule Day3_2 do
  @slopes [{1,1}, {3,1}, {5,1}, {7,1}, {1,2}]
  def test(input) do
    map = Util.lines(input) |> Enum.map(&parse_line/1)
    Enum.map(@slopes, &(do_walk(map, {0, 0}, &1, 0)))
    |> Enum.reduce(&Kernel.*/2)
  end
  def do_walk(map, {x, y}, {dx, dy}, count) do
    case Enum.at(map, y) do
      nil -> count
      line -> fn() ->
        x = Integer.mod(x, Enum.count(line))
        case Enum.at(line, x) do
          nil -> raise "Could not find entry in #{line} at #{x}"
          :empty -> do_walk(map, {x + dx, y + dy}, {dx, dy}, count)
          :tree -> do_walk(map, {x + dx, y + dy}, {dx, dy}, count + 1)
        end
      end.()
    end
  end

  def parse_line(line) do
    String.codepoints(line)
    |> Enum.map(&parse_character/1)
  end

  def parse_character(character) when character == "." do
    :empty
  end

  def parse_character(character) when character == "#" do
    :tree
  end

  def parse_character(c) do
    raise "invalid character: #{c}"
  end
end
