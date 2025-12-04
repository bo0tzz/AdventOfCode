import advent
import day_01
import day_02
import day_03

pub fn main() -> Nil {
  run_advent()
}

pub fn run_advent() {
  advent.year(2025)
  |> advent.timed
  |> advent.add_day(day_01.day())
  |> advent.add_day(day_02.day())
  |> advent.add_day(day_03.day())
  |> advent.add_padding_days(12)
  |> advent.run()
}
