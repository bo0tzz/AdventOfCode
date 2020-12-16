defmodule AdventOfCode do
  use Application

  @moduledoc """
  Documentation for AdventOfCode.
  """

  def day_modules() do
    modules = for day <- 1..25, part <- 1..2 do
      try do
        String.to_existing_atom("Elixir.Day#{day}_#{part}")
      rescue
        ArgumentError -> nil
      end
    end
    |> Enum.filter(&!is_nil(&1))

    # Run the most recent module first
    {tail, modules} = List.pop_at(modules, -1)
    [tail | modules]
  end

  def start(_type, _args) do
    Process.flag(:trap_exit, false)
    main()
    {:ok, self()}
  end

  def main do
    day_modules() |> Enum.map(&run_module_async/1) |> receive_results()
  end

  def receive_results([]), do: :ok
  def receive_results([{_, module} | rest]) do
    receive do
      {^module, result, time} ->
        log_result(module, result, time)
        receive_results(rest)
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
    pid = spawn_link(fn -> run_module(module, current) end)
    {pid, module}
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
