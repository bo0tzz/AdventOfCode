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
    for module <- @aoc_modules do
      read_input(module)
      |> module.test
      |> IO.puts
    end
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
