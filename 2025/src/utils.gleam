import gleam/int
import gleam/list
import gleam/order
import gleam/string

pub fn parse_int(string: String) -> Int {
  let assert Ok(int) = int.parse(string) as { "invalid int: " <> string }
  int
}

pub fn lines(string: String) -> List(String) {
  string |> string.trim() |> string.split("\n") |> list.map(string.trim)
}

pub fn ok(res: Result(a, _)) -> a {
  let assert Ok(value) = res
  value
}

pub type Range {
  Range(from: Int, to: Int)
}

pub fn parse_range(string: String) -> Range {
  let assert [from, to] =
    string.trim(string)
    |> string.split("-")
    as { "invalid range: " <> string }

  Range(from: parse_int(from), to: parse_int(to))
}

pub fn range_to_list(range: Range) -> List(Int) {
  list.range(range.from, range.to)
}

pub fn range_contains(range: Range, number: Int) -> Bool {
  case range.from, range.to {
    from, to if from <= number && to >= number -> True
    _, _ -> False
  }
}

pub fn range_size(range: Range) -> Int {
  range.to - range.from + 1
}

pub fn range_compare(a: Range, b: Range) -> order.Order {
  int.compare(a.from, b.from)
}

pub fn range_overlaps(a: Range, b: Range) -> Bool {
  case a, b {
    Range(_, to), Range(from, _) if to >= from - 1 -> True
    _, _ -> False
  }
}
