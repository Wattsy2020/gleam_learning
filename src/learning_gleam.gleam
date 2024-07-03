import arithmetic
import collections
import gleam/float
import gleam/int
import gleam/io
import gleam/list
import triples

pub fn main() {
  io.println("Result of basics: " <> arithmetic.basics() |> float.to_string)
  io.println(
    "Count of nums greater than 2: "
    <> { collections.listresult() |> int.to_string },
  )
  {
    let #(string_result, sum_result) = collections.tuples()
    io.println(
      "Result of tuple calculation: ("
      <> string_result
      <> ", "
      <> int.to_string(sum_result)
      <> ")",
    )
  }
  {
    io.println("Pythagorean Triples:")
    triples.calc_triples(20)
    |> list.each(fn(pair) {
      let #(x, y) = pair
      io.println("(" <> int.to_string(x) <> ", " <> int.to_string(y) <> ")")
    })
  }
}
