defmodule Day8_1 do
  def test(input) do
    Util.lines(input)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_instruction/1)
    |> execute()
  end

  def execute(instructions), do: execute({0, 0}, instructions, [])

  def execute({pc, acc}, instructions, seen) do
    case pc in seen do
      true -> acc
      false ->
        Enum.at(instructions, pc)
        |> run_instruction(pc, acc)
        |> execute(instructions, [pc | seen])
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
