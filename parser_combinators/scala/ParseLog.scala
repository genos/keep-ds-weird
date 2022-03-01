import scala.io.Source
import $ivy.`org.scala-lang.modules::scala-parser-combinators:2.1.1`, scala.util.parsing.combinator.RegexParsers

/* data types */

// output helper
object Pad {
  def apply(x: Any, len: Int): String =
    "0" * math.max(len - x.toString.length, 0) + x.toString
}

sealed trait SensorID
case object A extends SensorID
case object B extends SensorID
case object C extends SensorID

case class Date(year: Int, month: Int, day: Int) {
  override def toString(): String =
    Seq(Pad(year, 4), Pad(month, 2), Pad(day, 2)).mkString("-")
}

case class Time(hour: Int, minute: Int, second: Int) {
  override def toString(): String =
    Seq(Pad(hour, 2), Pad(minute, 2), Pad(second, 2)).mkString(":")
}

case class Fahrenheit(fahrenheit: Double) extends AnyVal {
  override def toString(): String = s"$fahrenheit°F"
}

case class Percentage(percentage: Double) extends AnyVal {
  override def toString(): String = s"$percentage%"
}

sealed trait Direction
case object N extends Direction
case object S extends Direction
case object E extends Direction
case object W extends Direction

case class MilesPerHour(milesPerHour: Int) extends AnyVal {
  override def toString(): String = s"${milesPerHour}mph"
}

case class Wind(direction: Direction, speed: MilesPerHour) {
  override def toString(): String = s"$direction@$speed"
}

case class Entry(
  sensorID: SensorID,
  date:     Date,
  time:     Option[Time],
  temp:     Fahrenheit,
  humidity: Percentage,
  wind:     Option[Wind]
)

/* parsing */

class Parser extends RegexParsers {
  def sensorID: Parser[SensorID] =
    ("A" ^^^ A) | ("B" ^^^ B) | ("C" ^^^ C)
  def date: Parser[Date] =
    """\d{4}""".r ~ "-" ~ """\d{2}""".r ~ "-" ~ """\d{2}""".r ^^ {
      case y ~ _ ~ m ~ _ ~ d => Date(y.toInt, m.toInt, d.toInt)
    }
  def time: Parser[Time] =
    """\d{2}""".r ~ ":" ~ """\d{2}""".r ~ ":" ~ """\d{2}""".r ^^ {
      case h ~ _ ~ m ~ _ ~ s => Time(h.toInt, m.toInt, s.toInt)
    }
  def temp: Parser[Fahrenheit] =
    """\d+[.]\d+""".r ^^ { s => Fahrenheit(s.toDouble) }
  def humidity: Parser[Percentage] =
    """\d+""".r ~ "%" ^^ { case p ~ _ => Percentage(p.toDouble) }
  def direction: Parser[Direction] =
    ("N" ^^^ N) | ("S" ^^^ S) | ("E" ^^^ E) | ("W" ^^^ W)
  def speed: Parser[MilesPerHour] =
    """\d+""".r ^^ { m => MilesPerHour(m.toInt) }
  def wind: Parser[Wind] =
    direction ~ speed ^^ { case d ~ s => Wind(d, s) }
  def entry: Parser[Entry] =
    sensorID ~ date ~ time.? ~ temp ~ humidity ~ wind.? ^^ {
      case s ~ d ~ tm ~ tp ~ h ~ w => Entry(s, d, tm, tp, h, w)
    }
}

/* main event */

@main
def main() = {
  val p = new Parser
  Source.fromFile("../data.log").getLines foreach { line =>
    println(p.parse(p.entry, line))
  }
}
