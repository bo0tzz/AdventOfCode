import advent
import gleam/dict
import gleam/function
import gleam/list
import gleam/option
import gleam/pair
import gleam/set
import gleam/string
import gleam_community/maths
import utils

pub fn day() {
  advent.Day(
    day: 04,
    parse:,
    part_a:,
    expected_a: option.Some(1516),
    wrong_answers_a: [],
    part_b:,
    expected_b: option.Some(9122),
    wrong_answers_b: [],
  )
}

pub type Position {
  Position(x: Int, y: Int)
}

fn position_from_tuple(tuple: #(Int, Int)) -> Position {
  let #(x, y) = tuple
  Position(x:, y:)
}

pub type Shelf {
  Roll
  None
}

fn shelf_from_string(string: String) -> Shelf {
  case string {
    "@" -> Roll
    "." -> None
    other -> panic as { "Invalid shelf content: " <> other }
  }
}

pub type Warehouse =
  dict.Dict(Position, Shelf)

pub type Input {
  Input(positions: Warehouse)
}

pub fn parse(input: String) -> Input {
  let lines = utils.lines(input)
  let positions =
    list.index_map(lines, fn(row, x) {
      string.split(row, "")
      |> list.index_map(fn(shelf, y) {
        #(Position(x:, y:), shelf_from_string(shelf))
      })
    })
    |> list.flatten()
    |> dict.from_list()
  Input(positions:)
}

pub fn part_a(input: Input) {
  retrievable_rolls(input.positions)
  |> pair.first()
  |> list.length()
}

pub fn part_b(input: Input) {
  retrieve_rolls_when_possible(input.positions)
}

fn neighbours(position: Position) -> List(Position) {
  let x_range = list.range(position.x - 1, position.x + 1) |> set.from_list()
  let y_range = list.range(position.y - 1, position.y + 1) |> set.from_list()

  maths.cartesian_product(x_range, y_range)
  |> set.map(position_from_tuple)
  |> set.drop([position])
  |> set.to_list()
}

fn retrievable_rolls(warehouse: Warehouse) {
  dict.filter(warehouse, fn(_, p) { p == Roll })
  |> dict.to_list()
  |> list.partition(fn(value) {
    let #(position, _) = value
    let retrievable_neighbours =
      neighbours(position)
      |> list.map(fn(position) {
        case dict.get(warehouse, position) {
          Ok(shelf) -> {
            case shelf {
              Roll -> True
              None -> False
            }
          }
          Error(_) -> False
        }
      })
      |> list.count(function.identity)
    retrievable_neighbours < 4
  })
}

fn retrieve_rolls_when_possible(warehouse: Warehouse) {
  case retrievable_rolls(warehouse) {
    #([], _) -> 0
    #(retrieved, rest) -> {
      list.length(retrieved)
      + retrieve_rolls_when_possible(dict.from_list(rest))
    }
  }
}
