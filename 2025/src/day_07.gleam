import advent
import gleam/dict
import gleam/list
import gleam/option
import gleam/string
import utils

pub fn day() {
  advent.Day(
    day: 07,
    parse:,
    part_a:,
    expected_a: option.Some(1550),
    wrong_answers_a: [],
    part_b:,
    expected_b: option.None,
    wrong_answers_b: [],
  )
}

pub type Point {
  Empty
  Source
  Splitter
  Beam
}

fn point_from_string(string: String) -> Point {
  case string {
    "." -> Empty
    "S" -> Source
    "^" -> Splitter
    "|" -> Beam
    other -> panic as { "invalid point: " <> other }
  }
}

/// y, x; top left is 0, 0
pub type Coordinate =
  #(Int, Int)

pub type Direction {
  Up
  Down
  Left
  Right
}

pub fn move(coordinate: Coordinate, direction: Direction) {
  let #(y, x) = coordinate
  case direction {
    Up -> #(y - 1, x)
    Right -> #(y, x + 1)
    Left -> #(y, x - 1)
    Down -> #(y + 1, x)
  }
}

pub type Input {
  Input(
    to_visit: List(Coordinate),
    grid: dict.Dict(Coordinate, Point),
    visited_splitters: Int,
  )
}

pub fn parse(input: String) -> Input {
  let grid_list =
    utils.lines_trimmed(input)
    |> list.index_map(fn(line, y) {
      string.split(line, "")
      |> list.index_map(fn(point, x) { #(#(y, x), point_from_string(point)) })
    })
    |> list.flatten()

  let assert Ok(#(source, _)) =
    list.find(grid_list, fn(entry) { entry.1 == Source })

  Input(
    to_visit: [source],
    grid: dict.from_list(grid_list),
    visited_splitters: 0,
  )
}

pub fn part_a(input: Input) {
  loop(input).visited_splitters
}

fn loop(input: Input) {
  case input {
    Input([], _, _) -> input
    _ -> input |> step() |> loop()
  }
}

fn step(input: Input) {
  list.fold(
    input.to_visit,
    Input(
      grid: input.grid,
      to_visit: [],
      visited_splitters: input.visited_splitters,
    ),
    fn(acc: Input, coordinate: Coordinate) {
      let next_point = move(coordinate, Down)
      case dict.get(acc.grid, next_point) {
        Ok(Empty) -> {
          let next_grid = dict.insert(acc.grid, next_point, Beam)
          Input(
            grid: next_grid,
            to_visit: [next_point, ..acc.to_visit],
            visited_splitters: acc.visited_splitters,
          )
        }
        Ok(Splitter) -> {
          let left = move(next_point, Left)
          let right = move(next_point, Right)
          let next_grid =
            acc.grid |> dict.insert(left, Beam) |> dict.insert(right, Beam)
          Input(
            grid: next_grid,
            to_visit: [left, right, ..acc.to_visit],
            visited_splitters: acc.visited_splitters + 1,
          )
        }
        Ok(Beam) -> acc
        Ok(Source) -> panic as "spacetime has collapsed"
        Error(_) -> acc
      }
    },
  )
}

pub fn part_b(input: Input) {
  input
  Nil
}
