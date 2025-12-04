import advent
import gleam/function
import gleam/int
import gleam/list
import gleam/option
import gleam/string
import utils

pub fn day() {
  advent.Day(
    day: 02,
    parse:,
    part_a:,
    expected_a: option.Some(18_595_663_903),
    wrong_answers_a: [],
    part_b:,
    expected_b: option.Some(19_058_204_438),
    wrong_answers_b: [],
  )
}

pub type Range {
  Range(from: Int, to: Int)
}

fn parse_range(string: String) -> Range {
  let assert [from, to] =
    string.trim(string)
    |> string.split("-")
    as { "invalid range: " <> string }

  Range(from: utils.parse_int(from), to: utils.parse_int(to))
}

pub type Input {
  Input(ranges: List(Range))
}

pub fn parse(input: String) -> Input {
  let ranges =
    string.trim(input)
    |> string.split(",")
    |> list.map(parse_range)

  Input(ranges:)
}

pub fn part_a(input: Input) {
  list.map(input.ranges, fn(range) { list.range(range.from, range.to) })
  |> list.flatten()
  |> list.filter(is_repetitive(_, 2))
  |> int.sum()
}

pub fn part_b(input: Input) {
  list.map(input.ranges, fn(range) { list.range(range.from, range.to) })
  |> list.flatten()
  // Ideally this should be unlimited but it's probably fine
  |> list.filter(is_repetitive(_, 20))
  |> int.sum()
}

fn is_repetitive(num: Int, up_to_times: Int) -> Bool {
  let digits = int.to_string(num)
  let len = string.length(digits)
  let slices = slice_until(digits, len / 2)
  list.map(slices, fn(slice) {
    let slice_len = string.length(slice)
    case len / slice_len {
      1 -> False
      l if l > up_to_times -> False
      l -> {
        let repeated = string.repeat(slice, l)
        repeated == digits
      }
    }
  })
  |> list.any(function.identity)
}

fn slice_until(string: String, until: Int) -> List(String) {
  list.range(1, until)
  |> list.map(fn(chars) { string.slice(string, 0, chars) })
}
