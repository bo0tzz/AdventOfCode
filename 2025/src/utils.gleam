import gleam/int
import gleam/list
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