import advent
import gleam/bool
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
    expected_b: option.Some(169_709_990_062_889),
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
    find_largest_series(bank.batteries, 2)
    |> int.undigits(10)
    |> utils.ok()
  })
  |> int.sum()
}

pub fn part_b(input: Input) {
  list.map(input.banks, with: fn(bank) {
    find_largest_series(bank.batteries, 12)
    |> int.undigits(10)
    |> utils.ok()
  })
  |> int.sum()
}

pub fn find_largest_series(digits: List(Int), limit: Int) {
  use <- bool.guard(limit <= 1, [list.max(digits, int.compare) |> utils.ok()])
  let take = list.length(digits) - limit + 1

  case list.split(digits, take) {
    #(left, []) -> left
    #(head, _) -> {
      let chosen_digit =
        list.index_fold(head, Accumulator(0, 0), fn(acc, digit, index) {
          case int.compare(acc.largest_digit, digit) {
            order.Lt -> Accumulator(digit, index)
            order.Gt -> acc
            order.Eq -> acc
          }
        })
      let #(_, cont) = list.split(digits, chosen_digit.index + 1)
      list.append(
        [chosen_digit.largest_digit],
        find_largest_series(cont, limit - 1),
      )
    }
  }
}

type Accumulator {
  Accumulator(largest_digit: Int, index: Int)
}
