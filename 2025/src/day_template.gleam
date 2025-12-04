import advent
import gleam/option

pub fn day() {
  advent.Day(
    day: 00,
    parse:,
    part_a:,
    expected_a: option.None,
    wrong_answers_a: [],
    part_b:,
    expected_b: option.None,
    wrong_answers_b: [],
  )
}

pub type Input {
  Input()
}

pub fn parse(input: String) -> Input {
  Input
}

pub fn part_a(input: Input) {
  input
}

pub fn part_b(input: Input) {
  input
}
