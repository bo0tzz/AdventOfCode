defmodule AdventOfCode.MixProject do
  use Mix.Project

  def project do
    [
      app: :advent_of_code,
      version: "2021.0.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {AdventOfCode, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
    ]
  end
end
