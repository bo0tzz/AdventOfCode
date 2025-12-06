import advent
import gleam/int
import gleam/list
import gleam/option
import gleam/string
import utils

pub fn day() {
  advent.Day(
    day: 05,
    parse:,
    part_a:,
    expected_a: option.Some(505),
    wrong_answers_a: [],
    part_b:,
    expected_b: option.Some(344_423_158_480_189),
    wrong_answers_b: [],
  )
}

pub type Input {
  Input(fresh: List(utils.Range), ingredients: List(Int))
}

pub fn parse(input: String) -> Input {
  let assert Ok(#(ranges_str, ingredients_str)) =
    string.split_once(input, "\n\n")
  let fresh =
    utils.lines_trimmed(ranges_str)
    |> list.map(utils.parse_range)

  let ingredients = utils.lines_trimmed(ingredients_str) |> list.map(utils.parse_int)

  Input(fresh:, ingredients:)
}

pub fn part_a(input: Input) {
  list.count(input.ingredients, fn(ingredient) {
    list.any(input.fresh, utils.range_contains(_, ingredient))
  })
}

pub fn part_b(input: Input) {
  list.sort(input.fresh, utils.range_compare)
  |> list.fold([], fn(acc, range) {
    case list.last(acc) {
      Error(_) -> [range]
      Ok(previous) -> {
        case utils.range_overlaps(previous, range) {
          True -> {
            let new_range =
              utils.Range(previous.from, int.max(previous.to, range.to))
            list.reverse(acc)
            |> list.drop(1)
            |> list.prepend(new_range)
            |> list.reverse()
          }
          False -> list.append(acc, [range])
        }
      }
    }
  })
  |> list.map(utils.range_size)
  |> int.sum()
}
