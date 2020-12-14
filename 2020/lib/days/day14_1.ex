defmodule Day14_1 do
  @instruction_regex ~r/mem\[(\d+)\] = (\d+)/
  def test(input) do
    Util.lines(input)
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(%{mask: nil, memory: %{}}, &run_instruction/2)
    |> Map.get(:memory)
    |> Map.values()
    |> Enum.sum()
  end

  def run_instruction({:mask, mask, and_mask}, state), do: %{state | mask: {mask, and_mask}}

  def run_instruction({:write, address, val}, %{mask: mask, memory: memory} = state),
    do: %{state | memory: Map.put(memory, address, apply_mask(mask, val))}

  def parse_line("mask = " <> mask), do: parse_mask(mask)

  def parse_line(instruction) do
    [_, address, val] = Regex.run(@instruction_regex, instruction)
    {address, _} = Integer.parse(address)
    {val, _} = Integer.parse(val)
    {:write, address, val}
  end

  def parse_mask(mask) do
    and_mask = Regex.replace(~r/[01]/, mask, "0")
    {and_mask, _} = Regex.replace(~r/X/, and_mask, "1") |> Integer.parse(2)
    {mask, _} = Regex.replace(~r/X/, mask, "0") |> Integer.parse(2)
    {:mask, mask, and_mask}
  end

  def apply_mask({mask, and_mask}, value), do: Bitwise.band(and_mask, value) |> Bitwise.bor(mask)
end
