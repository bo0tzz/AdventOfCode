defmodule Day16_2 do
  @rule_regex ~r/([\w\s]+): (\d+)-(\d+) or (\d+)-(\d+)/
  def test(input) do
    [rules, ticket, nearby] = String.split(input, ["your ticket:", "nearby tickets:"])
    rules = Util.lines(rules) |> parse_rules()
    nearby = Util.lines(nearby) |> Enum.map(&parse_ticket/1)
    ticket = parse_ticket(ticket)

    c = Enum.reduce(nearby, %{}, &search_field_candidates(&1, &2, rules))

    fields = find_fields([], c)
    Enum.map(fields, fn {i, ms} ->
      [field] = MapSet.to_list(ms)
      {i, field}
    end)
    |> Enum.filter(fn {_, field} -> match?("departure"<>_, field) end)
    |> Enum.map(fn {i, _} ->
      Enum.at(ticket, i)
    end)
    |> Enum.reduce(1, &Kernel.*/2)

  end

  def find_fields(fields, [{i, candidate}]) do
    ms = MapSet.difference(
      candidate,
      Enum.reduce(fields, MapSet.new(), fn ({_, ms}, acc) -> MapSet.union(acc, ms) end)
    )
    [{i, ms} | fields]
  end
  def find_fields(fields, candidates) do
    {known, candidates} = Enum.map(candidates, fn {i, ms} ->
      present_in_others = Enum.reject(candidates, &match?({^i, _}, &1))
      |> Enum.reduce(MapSet.new(), fn ({_, ms}, acc) -> MapSet.union(acc, ms) end)
      uniq = MapSet.difference(ms, present_in_others)
      case MapSet.size(uniq) do
        1 -> {i, uniq}
        _ -> {i, ms}
      end
    end)
    |> Enum.split_with(fn {_, c} ->
      MapSet.size(c) == 1
    end)
    find_fields(fields ++ known, candidates)
  end

  def search_field_candidates(ticket, candidates, rules) do
    case all_fields_valid?(ticket, rules) do
      false ->
        candidates

      true ->
        Enum.with_index(ticket)
        |> Enum.reduce(candidates, fn ({field, index}, c) ->
          valid = find_valid_rules(field, rules) |> Enum.map(fn {name, _, _} -> name end) |> MapSet.new()
          Map.update(c, index, valid, &MapSet.intersection(&1, valid))
        end)
    end
  end

  def find_valid_rules(field, rules) do
    Enum.filter(rules, &is_valid(field, &1))
  end

  def all_fields_valid?(ticket, rules) do
    Enum.all?(ticket, &is_valid_for_any_rule?(&1, rules))
  end

  def is_valid_for_any_rule?(field, rules) do
    Enum.any?(rules, &is_valid(field, &1))
  end

  def is_valid(field, {_, {from, to}, _}) when field >= from and field <= to, do: true
  def is_valid(field, {_, _, {from, to}})  when field >= from and field <= to, do: true
  def is_valid(_, _), do: false

  def parse_ticket(ticket) do
    String.split(ticket, ",", trim: true) |> Enum.map(&int/1)
  end

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
