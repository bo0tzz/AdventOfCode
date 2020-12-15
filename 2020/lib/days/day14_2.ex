defmodule Day14_2 do
  @instruction_regex ~r/mem\[(\d+)\] = (\d+)/
  def test(input) do
    Util.lines(input)
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(%{mask: nil, memory: %{}}, &run_instruction/2)
    |> Map.get(:memory)
    |> Map.values()
    |> Enum.sum()
  end

  def run_instruction({:mask, masks}, state) do
    IO.puts("Writing masks #{inspect(masks)} into state #{inspect(state)}")
    %{state | mask: masks}
  end

  def run_instruction({:write, address, val}, %{mask: masks, memory: memory} = state) do
    IO.puts("Writing #{val} to address #{address} masked by #{inspect(masks)}")

    %{
      state
      | memory:
          Enum.reduce(masks, memory, fn mask, mem ->
            a = Bitwise.bor(address, mask)
            IO.puts("#{address} masked by #{mask} becomes #{a}")
            Map.put(mem, a, val)
          end)
    }
  end

  def parse_line("mask = " <> mask), do: {:mask, parse_masks(mask) |> List.flatten()}

  def parse_line(instruction) do
    [_, address, val] = Regex.run(@instruction_regex, instruction)
    {address, _} = Integer.parse(address)
    {val, _} = Integer.parse(val)
    {:write, address, val}
  end

  def parse_masks(mask) do
    IO.puts("Parsing mask #{mask}")

    case String.contains?(mask, "X") do
      false ->
        Integer.parse(mask, 2) |> elem(0) |> IO.inspect(label: "parsed")

      true ->
        zero = String.replace(mask, "X", "0", global: false)
        one = String.replace(mask, "X", "1", global: false)
        [parse_masks(zero), parse_masks(one)]
    end
  end

  def apply_mask({mask, and_mask}, value), do: Bitwise.band(and_mask, value) |> Bitwise.bor(mask)
end
