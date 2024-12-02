import day1/input.{input}
import gleam/int
import gleam/io
import gleam/list
import gleam/order
import gleam/result

fn difference(tup: #(Int, Int)) -> Int {
  case tup {
    #(l, r) if l > r -> l - r
    #(l, r) if r > l -> r - l
    #(_same, _same) -> 0
  }
}

pub fn run() {
  let #(left, right) = input()
  let left = list.sort(left, by: int.compare)
  let right = list.sort(right, by: int.compare)
  list.zip(left, right)
  |> list.map(difference)
  |> list.reduce(int.add)
  |> io.debug()
}
