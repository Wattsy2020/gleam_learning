import arithmetic
import collections
import gleam/float
import gleam/int
import gleam/io
import gleam/string
import triples

pub fn main() {
  io.println("Result of basics: " <> arithmetic.basics() |> float.to_string)
  io.println(
    "Count of nums greater than 2: "
    <> { collections.listresult() |> int.to_string },
  )
  io.println(
    "Result of tuple calculation: " <> string.inspect(collections.tuples()),
  )
  io.println(
    "Pythagorean Triples: " <> string.inspect(triples.calc_triples(100)),
  )
}
