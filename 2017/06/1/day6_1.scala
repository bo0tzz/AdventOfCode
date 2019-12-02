object AoC {

  def main(args: Array[String]): Unit = {
    val lines = scala.io.Source.fromFile("in.txt").getLines().toList
    var list: List[Int] = lines.head.split("\\s").filter(_ != "").map(_.toInt).toList
    var resultSet: collection.mutable.Set[List[Int]] = collection.mutable.Set.empty
    var counter: Int = 0
    while (resultSet add list) {
      val max = highestVal(list)
      list = reorder(list, max._1)
      counter += 1
    }
    println(counter)
  }

  def highestVal(list: List[Int]): (Int, Int) = { // Take array, return (bank, blocks) for the bank with the highest # blocks
    var max: (Int, Int) = (0, 0) // (bank, blocks)
    var i: Int = 0 // index
    list.foreach((p) => {
      if (p > max._2) max = (i, list(i))
      i += 1
    })
    max
  }

  def reorder(list: List[Int], bank: Int): List[Int] = { // Start is a tuple of (index, value)
    var blocks: Int = list(bank)
    var out = list updated (bank, 0)
    var index = bank
    while (blocks > 0) {
      if (index >= out.length - 1) index = 0 else index += 1
      out = out updated (index, out(index) + 1)
      blocks -= 1
    }
    out
  }

}