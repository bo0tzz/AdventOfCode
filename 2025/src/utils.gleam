import gleam/int

pub fn parse_int(string: String) -> Int {
  let assert Ok(int) = int.parse(string) as { "invalid int: " <> string }
  int
}
