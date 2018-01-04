import scala.util.parsing.combinator._

// helper
object Pad {
  def pad(i: Int, len: Int): String = {
    val s = i.toString
    "0" * math.max(len - s.length, 0) + s
  }
}

/* data types */

sealed trait SensorID
case object A extends SensorID
case object B extends SensorID
case object C extends SensorID

case class Date(year: Int, month: Int, day: Int) {
  override def toString(): String =
    Pad.pad(year, 4) + "-" + Pad.pad(month, 2) + "-" + Pad.pad(day, 2)
}

case class Time(hour: Int, minute: Int, second: Int) {
  override def toString(): String =
    Pad.pad(hour, 2) + "-" + Pad.pad(minute, 2) + "-" + Pad.pad(second, 2)
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
  date: Date,
  time: Option[Time],
  temp: Fahrenheit,
  humidity: Percentage,
  wind: Option[Wind]
)

/* parsing */

// TODO

case class WordFreq(word: String, count: Int) {
  override def toString = "Word<" + word + "> " + "occurs with frequency " + count
}

class SimpleParser extends RegexParsers {
  def word: Parser[String]   = """[a-z]+""".r       ^^ { _.toString }
  def number: Parser[Int]    = """(0|[1-9]\d*)""".r ^^ { _.toInt }
  def freq: Parser[WordFreq] = word ~ number        ^^ { case wd ~ fr => WordFreq(wd, fr) }
}

/* main event */

// TODO

object TestSimpleParser extends SimpleParser {
  def main(args: Array[String]): Unit = {
    parse(freq, "johnny 121") match {
      case Success(matched,_) => println(matched)
      case Failure(msg,_) => println("FAILURE: " + msg)
      case Error(msg,_) => println("ERROR: " + msg)
    }
  }
}
