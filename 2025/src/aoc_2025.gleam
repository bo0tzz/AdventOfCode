import day_01
import advent

pub fn main() -> Nil {
  advent.year(2025)
  |> advent.timed
  |> advent.add_day(day_01.day())
  |> advent.add_padding_days(12)
  |> advent.run()
}
