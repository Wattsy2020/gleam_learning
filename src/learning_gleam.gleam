import arithmetic
import birl/duration
import collections
import concurrent
import gleam/erlang/process
import gleam/float
import gleam/int
import gleam/io
import gleam/string
import iterator
import triples
import xml

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
  io.println(
    "Pythagorean Triples evaluated in parallel: "
    <> string.inspect(triples.calc_triples_parallel(2000)),
  )

  io.println("Iterating over sleep calls")
  let sleep10 = fn() {
    process.sleep(10)
    io.println("Sleep10 finished")
    1
  }
  let sleep400 = fn() {
    process.sleep(400)
    io.println("Sleep400 finished")
    2
  }
  let sleep1000 = fn() {
    process.sleep(1000)
    io.println("Sleep1000 finished")
    3
  }
  let assert Ok(sleep_order) =
    concurrent.iterate_results([sleep10, sleep400, sleep1000])
    |> iterator.to_list(duration.milli_seconds(1100))
  io.debug(sleep_order)

  io.println("Iterating over pythagorean triples results")
  let _ =
    triples.calc_triples_iterator(2000)
    |> iterator.flatten
    |> iterator.map(io.debug)
    |> iterator.to_list(duration.milli_seconds(10))
    |> io.debug

  io.println("Valid XML")
  io.debug(xml.parse_xml("<hello>world</hello>"))
  io.println("Some invalid XML")
  io.debug(xml.parse_xml("<hello>world</wrongtag>"))
}
