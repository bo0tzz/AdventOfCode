import simplifile
import day_06
import advent
import day_01
import day_02
import day_03
import day_04
import day_05

pub fn main() -> Nil {
  run_advent()
}

pub fn run_advent() {
  let assert Ok(session) = simplifile.read("token.secret")
  advent.year(2025)
  |> advent.download_missing_days(session)
  |> advent.timed
  |> advent.add_day(day_01.day())
  |> advent.add_day(day_02.day())
  |> advent.add_day(day_03.day())
  |> advent.add_day(day_04.day())
  |> advent.add_day(day_05.day())
  |> advent.add_day(day_06.day())
  |> advent.add_padding_days(12)
  |> advent.run()
}
