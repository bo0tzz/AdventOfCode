import day1/input.{input}
import gleam/int
import gleam/io
import gleam/list

pub fn run() {
  let #(left, right) = input()

  let occurrences = fn(n) { list.count(right, fn(m) { n == m }) }

  list.map(left, fn(entry) {
    let count = occurrences(entry)
    entry * count
  })
  |> list.reduce(int.add)
  |> io.debug()
}
