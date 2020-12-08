defmodule Day8_2 do
  def test(input) do
    Util.lines(input)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_instruction/1)
    |> create_permutations()
    |> Enum.map(&execute/1)
    |> Enum.find(&is_success/1)
  end

  def is_success({:loop, _}), do: false
  def is_success({:done, _}), do: true

  def create_permutations(instructions) do
    0..Enum.count(instructions)
    |> Enum.map(fn (at) -> permute(instructions, at) end)
    |> Enum.reject(&is_nil/1)
  end

  def permute(instructions, at) do
    case Enum.at(instructions, at) do
      {:jmp, a} -> List.replace_at(instructions, at, {:nop, a})
      {:nop, a} -> List.replace_at(instructions, at, {:jmp, a})
      _ -> nil
    end
  end

  def execute(instructions), do: execute({0, 0}, instructions, [])

  def execute({pc, acc}, instructions, seen) do
    case pc in seen do
      true -> {:loop, acc}
      false ->
        case Enum.at(instructions, pc) do
          nil -> {:done, acc}
          i -> run_instruction(i, pc, acc) |> execute(instructions, [pc | seen])
        end
    end
  end

  def run_instruction({:acc, arg}, pc, acc), do: {pc + 1, acc + arg}
  def run_instruction({:jmp, arg}, pc, acc), do: {pc + arg, acc}
  def run_instruction({:nop, _}, pc, acc), do: {pc + 1, acc}

  def parse_instruction("jmp" <> arg), do: {:jmp, int(arg)}
  def parse_instruction("acc" <> arg), do: {:acc, int(arg)}
  def parse_instruction("nop" <> arg), do: {:nop, int(arg)}

  def int("-"<> n), do: 0 - elem(Integer.parse(n), 0)
  def int("+"<> n), do: elem(Integer.parse(n), 0)
  def int(n), do: String.trim(n) |> int()
end
