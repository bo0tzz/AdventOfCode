defmodule AdventOfCode do
  @moduledoc """
  Documentation for AdventOfCode.
  """

  @aoc_modules [
    Day1_1,
    Day1_2,
  ]
  @doc """
  Hello world.

  ## Examples

      iex> AdventOfCode.hello()
      :world

  """
  def main do
    children = Enum.map(@aoc_modules, &run_module_async/1)
    receive_results(Enum.count(children))
  end

  def receive_results(count) do
    if count == 0 do
      :done
    else
      receive do
        {module, result} -> log_result(module, result)
      end
      receive_results(count - 1)
    end
  end

  def log_result(module, result) do
    IO.inspect "Got result from module " <> Atom.to_string(module) <> ": [" <> Kernel.inspect(result) <> "]"
  end

  def run_module_async(module) do
    current = self()
    spawn (fn -> run_module(module, current) end)
  end

  def run_module(module, parent) do
    result = read_input(module)
    |> module.test

    send(parent, {module, result})
  end

  def read_input(module) do
    Atom.to_string(module)
    |> String.split(".")
    |> List.last
    |> String.split("_")
    |> List.first
    |> build_inputfile_path
    |> File.read!
  end

  def build_inputfile_path(atom_name) do
    "./input/" <> atom_name
  end
end

AdventOfCode.main()
