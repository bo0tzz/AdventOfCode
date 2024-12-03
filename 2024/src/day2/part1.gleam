import day2/input.{input}
import gleam/bool
import gleam/io
import gleam/list

fn as_change(report: List(Int)) -> List(Int) {
  list.window_by_2(report)
  |> list.map(fn(pair) {
    let #(l, r) = pair
    l - r
  })
}

fn is_safe(change: Int) -> Bool {
  case change {
    0 -> False
    c if -3 <= c && c <= 3 -> True
    _ -> False
  }
}

fn are_safe(level_changes: List(Int)) -> Bool {
  list.all(level_changes, is_safe)
}

fn is_uniform(level_changes: List(Int)) -> Bool {
  list.all(level_changes, fn(n) { n >= 0 })
  || list.all(level_changes, fn(n) { n <= 0 })
}

pub fn run() {
  let reports = input()
  list.map(reports, as_change)
  |> list.count(where: fn(l) { is_uniform(l) && are_safe(l) })
  |> io.debug()
}
