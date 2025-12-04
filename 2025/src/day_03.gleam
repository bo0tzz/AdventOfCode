import advent
import gleam/int
import gleam/list
import gleam/option
import gleam/order
import gleam/string
import utils

pub fn day() {
  advent.Day(
    day: 03,
    parse:,
    part_a:,
    expected_a: option.Some(17_113),
    wrong_answers_a: [],
    part_b:,
    expected_b: option.None,
    wrong_answers_b: [],
  )
}

pub type Bank {
  Bank(batteries: List(Int))
}

pub type Input {
  Input(banks: List(Bank))
}

pub fn parse(input: String) -> Input {
  let banks =
    utils.lines(input)
    |> list.map(fn(bank) {
      let batteries =
        string.to_graphemes(bank)
        |> list.map(utils.parse_int)
      Bank(batteries:)
    })
  Input(banks:)
}

pub fn part_a(input: Input) {
  list.map(input.banks, with: fn(bank) {
    find_largest_joltage(bank.batteries)
    |> digits_to_num()
  })
  |> int.sum()
}

pub fn part_b(input: Input) {
  0
}

fn digits_to_num(digits: #(Int, Int)) -> Int {
  let #(x, y) = digits
  x * 10 + y
}

fn find_largest_joltage(batteries: List(Int)) -> #(Int, Int) {
  case batteries {
    [] | [_] -> panic as "no batteries"
    [x, y] -> #(x, y)
    [x, ..rest] -> {
      let #(candidate_x, candidate_y) = find_largest_joltage(rest)
      let x_order = int.compare(x, candidate_x)
      let xy_order = int.compare(candidate_x, candidate_y)
      case x_order, xy_order {
        order.Lt, _ -> #(candidate_x, candidate_y)
        order.Gt, order.Gt -> #(x, candidate_x)
        order.Gt, _ -> #(x, candidate_y)
        order.Eq, order.Gt -> #(x, candidate_x)
        order.Eq, _ -> #(x, candidate_y)
      }
    }
  }
}
