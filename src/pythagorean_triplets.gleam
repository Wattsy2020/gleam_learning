import arithmetic
import collections
import gleam/float
import gleam/int
import gleam/io

pub fn main() {
  io.println("Hello from pythagorean_triplets!")
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
}
