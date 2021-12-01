defmodule Util do
  def lines(string) do
    String.trim(string)
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
  end

  def parse_int(string) do
    {int, _} = Integer.parse(string)
    int
  end

end
