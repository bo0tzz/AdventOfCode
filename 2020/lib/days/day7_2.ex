defmodule Day7_2 do
  @bag_regex ~r/((?<num>\d+)( ))?(?<colour>(\w+\s\w+)) bag(s)?/

  def test(input) do
    Util.lines(input)
    |> Enum.map(&parse_rule/1)
    |> Enum.reduce(:digraph.new(), &add_to_graph/2)
    |> find_contents("shiny gold")
    |> List.flatten()
    |> Enum.count()
    |> (&(&1 - 1)).()
  end

  def find_contents(graph, bag) do
    case :digraph.out_edges(graph, bag) do
      [] -> bag
      edges -> [bag | Enum.map(edges, &(follow_edge(graph, &1)))]
    end
  end

  def follow_edge(graph, edge) do
    case :digraph.edge(graph, edge) do
      false -> nil
      {_, _, to, count} -> for _ <- 1..count, do: find_contents(graph, to)
    end
  end

  def add_to_graph(rule, graph) do
    {{_, from}, to} = rule
    :digraph.add_vertex(graph, from)
    for {n, c} <- to do
      :digraph.add_vertex(graph, c)
      :digraph.add_edge(graph, from, c, n)
    end
    graph
  end

  def parse_rule(rule) do
    [outer_bag, contents] =  String.split(rule, "contain")
    contents = case contents do
      " no other bags." -> []
      c -> String.split(c, ",") |> Enum.map(&parse_bag/1)
    end
    {parse_bag(outer_bag), contents}
  end

  def parse_bag(bag) do
    res = Regex.named_captures(@bag_regex, bag)
    num = case Map.fetch(res, "num") do
      {:ok, ""} -> 1
      :error -> 1
      {:ok, n} -> case Integer.parse(n) do
        {n, _} -> n
      end
    end
    {num, Map.fetch!(res, "colour")}
  end
end
