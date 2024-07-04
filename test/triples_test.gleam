import arithmetic
import extended_should
import gleam/int
import gleam/result
import gleeunit/should
import triples

const expected_triples_under_twenty = [
  #(3, 4), #(5, 12), #(6, 8), #(8, 15), #(9, 12), #(12, 16), #(15, 20),
]

pub fn triples_test() {
  triples.calc_triples(20)
  |> should.equal(expected_triples_under_twenty)
}

pub fn triples_property_test() {
  triples.calc_triples(1000)
  |> extended_should.all_satisfy(
    fn(tuple) {
      let #(x, y) = tuple
      x > 0
      && y > 0
      && arithmetic.is_near_integer(result.unwrap(
        int.square_root(arithmetic.square_int(x) + arithmetic.square_int(y)),
        0.5,
      ))
    },
    fn(tuple) {
      let #(x, y) = tuple
      "(" <> int.to_string(x) <> ", " <> int.to_string(y) <> ")"
    },
  )
}
