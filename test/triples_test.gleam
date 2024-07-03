import gleeunit/should
import triples

const expected_triples_under_twenty = [
  #(3, 4), #(5, 12), #(6, 8), #(8, 15), #(9, 12), #(12, 16), #(15, 20),
]

pub fn triples_test() {
  triples.calc_triples(20)
  |> should.equal(expected_triples_under_twenty)
}
