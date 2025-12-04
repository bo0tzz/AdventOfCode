import advent
import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/string
import utils

pub fn day() {
  advent.Day(
    day: 01,
    parse:,
    part_a:,
    expected_a: option.Some(989),
    wrong_answers_a: [],
    part_b:,
    expected_b: option.Some(5941),
    wrong_answers_b: [],
  )
}

pub type Rotation {
  Left(Int)
  Right(Int)
}

fn rotation_from_string(string: String) -> Rotation {
  case string {
    "L" <> n -> Left(utils.parse_int(n))
    "R" <> n -> Right(utils.parse_int(n))
    other -> panic as { "Invalid rotation: " <> other }
  }
}

fn rotate(position: Int, rotation: Rotation) -> Int {
  let delta = case rotation {
    Right(n) -> n
    Left(n) -> -n
  }

  position + delta
}

pub type Input {
  Input(rotations: List(Rotation), start: Int)
}

pub fn parse(input: String) -> Input {
  let rotations =
    input
    |> string.trim()
    |> string.split("\n")
    |> list.map(rotation_from_string)

  Input(rotations:, start: 50)
}

pub fn part_a(input: Input) {
  let #(_, stops) =
    list.map_fold(over: input.rotations, from: input.start, with: fn(acc, i) {
      let new_position = rotate(acc, i)
      let assert Ok(pos) = int.modulo(new_position, 100)
      #(pos, pos)
    })

  list.count(stops, where: fn(n) { n == 0 })
}

pub fn part_b(input: Input) {
  // Lazy approach: destructure rotations so we hit every digit stop
  let rotations =
    list.map(input.rotations, fn(rotation) {
      case rotation {
        Right(n) -> list.repeat(Right(1), times: n)
        Left(n) -> list.repeat(Left(1), times: n)
      }
    }) |> list.flatten()

  let #(_, stops) =
    list.map_fold(over: rotations, from: input.start, with: fn(acc, i) {
      let new_position = rotate(acc, i)
      let assert Ok(pos) = int.modulo(new_position, 100)
      #(pos, pos)
    })

  list.count(stops, where: fn(n) { n == 0 })
}
