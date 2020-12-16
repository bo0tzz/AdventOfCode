defmodule Day16_1 do
  @rule_regex ~r/(\w+): (\d+)-(\d+) or (\d+)-(\d+)/
  def test(input) do
    [rules, _, nearby] = String.split(input, ["your ticket:", "nearby tickets:"]) |> Enum.map(&Util.lines/1)
    rules = parse_rules(rules)
    nearby = Enum.map(nearby, fn nt -> String.split(nt, ",", trim: true) |> Enum.map(&int/1) end)
    check_tickets(nearby, rules) |> List.flatten() |> Enum.sum()
  end

  def check_tickets(tickets, rules) do
    Enum.map(tickets, &find_invalid_fields(&1, rules))
  end

  def find_invalid_fields(ticket, rules) do
    Enum.filter(ticket, & !is_valid_for_any(&1, rules))
  end

  def is_valid_for_any(field, rules) do
    Enum.any?(rules, &is_valid(field, &1))
  end

  def is_valid(field, {_, {a, b}, _}) when field >= a and field <= b, do: true
  def is_valid(field, {_, _, {c, d}})  when field >= c and field <= d, do: true
  def is_valid(_, _), do: false

  def parse_rules(rules) do
    Enum.filter(rules, & !match?("", &1))
    |> Enum.map(&parse_rule/1)
  end

  def parse_rule(rule) do
    [name, a, b, c, d] = Regex.run(@rule_regex, rule, capture: :all_but_first)
    {name, {int(a), int(b)}, {int(c), int(d)}}
  end

  def int(n) do
    String.trim(n) |> String.to_integer()
  end

end
