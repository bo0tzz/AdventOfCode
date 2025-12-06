import advent
import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/order
import gleam/string
import utils

pub fn day() {
  advent.Day(
    day: 06,
    parse:,
    part_a:,
    expected_a: option.Some(4_805_473_544_166),
    wrong_answers_a: [],
    part_b:,
    expected_b: option.Some(8_907_730_960_817),
    wrong_answers_b: [],
  )
}

pub type Operator {
  Add
  Multiply
}

fn parse_operator(operator: String) -> Operator {
  case string.trim(operator) {
    "+" -> Add
    "*" -> Multiply
    bad -> panic as { "invalid operator: " <> bad }
  }
}

fn operator_to_function(operator: Operator) {
  case operator {
    Multiply -> int.product
    Add -> int.sum
  }
}

pub type Column {
  Column(operands: List(String), operator: Operator)
}

pub type Input {
  Input(columns: List(Column))
}

pub fn parse(input: String) -> Input {
  let lines = string.split(input, "\n")

  let space_indices =
    list.flat_map(lines, fn(line) {
      string.to_graphemes(line)
      |> list.index_map(fn(g, index) { #(g, index) })
      |> list.key_filter(" ")
    })

  let space_index_counts =
    list.fold(space_indices, dict.new(), fn(counts, index) {
      dict.upsert(counts, index, fn(v) {
        case v {
          option.Some(existing) -> existing + 1
          option.None -> 1
        }
      })
    })

  let assert Ok(highest_count) =
    dict.values(space_index_counts)
    |> list.sort(order.reverse(int.compare))
    |> list.first()

  let split_columns =
    dict.filter(space_index_counts, fn(_, v) { v == highest_count })
    |> dict.keys()
    |> list.sort(int.compare)

  let columns =
    list.map(lines, fn(line) { utils.slice_on(line, split_columns) })
    |> list.transpose()

  let columns =
    list.map(columns, fn(column) {
      let len = list.length(column)
      let assert #(operands, [operator]) = list.split(column, len - 1)

      let operator = parse_operator(operator)
      Column(operands:, operator:)
    })

  Input(columns)
}

fn calculate(columns: List(Column)) -> List(Int) {
  list.map(columns, fn(column) {
    column.operands
    |> list.map(string.trim)
    |> list.map(utils.parse_int)
    |> operator_to_function(column.operator)
  })
}

pub fn part_a(input: Input) {
  calculate(input.columns)
  |> int.sum()
}

pub fn part_b(input: Input) {
  list.map(input.columns, fn(col) {
    let operands =
      list.map(col.operands, string.to_graphemes)
      |> list.transpose()
      |> list.map(string.concat)
    Column(operands:, operator: col.operator)
  })
  |> calculate()
  |> int.sum()
}
