defmodule AdventOfCode do
  use Application

  @moduledoc """
  Documentation for AdventOfCode.
  """

  @aoc_modules [
    Day1_1,
    Day1_2,
    Day2_1,
    Day2_2,
    Day3_1,
    Day3_2,
    Day4_1,
    Day4_2,
    Day5_1,
    Day5_2,
    Day6_1,
    Day6_2,
    Day7_1,
    Day7_2,
    Day8_1,
    Day8_2,
    Day9_1,
    Day9_2,
    Day10_1,
    Day10_2,
    Day11_1,
    Day11_2,
    Day12_1,
    Day12_2,
    Day13_1,
    Day13_2
  ]

  def start(_type, _args) do
    main()
    {:ok, self()}
  end

  def main do
    children = Enum.map(@aoc_modules, &run_module_async/1)
    receive_results(Enum.count(children))
  end

  def receive_results(count) do
    if count == 0 do
      :done
    else
      receive do
        {module, result, time} -> log_result(module, result, time)
      end

      receive_results(count - 1)
    end
  end

  def log_result(module, result, time) do
    IO.inspect(
      "Got result from module #{Atom.to_string(module)}: [#{Kernel.inspect(result)}] in #{
        time / 1000
      } ms"
    )
  end

  def run_module_async(module) do
    current = self()
    spawn(fn -> run_module(module, current) end)
  end

  def run_module(module, parent) do
    input = read_input(module)
    {time, result} = :timer.tc(module, :test, [input])
    send(parent, {module, result, time})
  end

  def read_input(module) do
    Atom.to_string(module)
    |> String.split(".")
    |> List.last()
    |> String.split("_")
    |> List.first()
    |> build_inputfile_path
    |> File.read!()
  end

  def build_inputfile_path(atom_name) do
    "./input/" <> atom_name
  end
end
