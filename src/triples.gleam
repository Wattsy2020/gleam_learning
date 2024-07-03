import arithmetic
import gleam/int
import gleam/list

fn is_triple(x: Int, y: Int) -> Bool {
  let sum_squares = arithmetic.square_int(x) + arithmetic.square_int(y)
  case int.square_root(sum_squares) {
    Ok(square_root) -> arithmetic.is_near_integer(square_root)
    Error(_) -> False
  }
}

/// Return a matrix containing all values (x, y) where x < n and y < n
fn matrix_range(n: Int) -> List(#(Int, Int)) {
  let num_range = list.range(1, n)
  list.map(num_range, fn(first_num) {
    list.map(num_range, fn(second_num) { #(first_num, second_num) })
  })
  |> list.flatten
}

/// Calculates all pythagorean triples (x, y) where x < n and y < n
pub fn calc_triples(n: Int) -> List(#(Int, Int)) {
  matrix_range(n)
  |> list.filter(fn(tuple) {
    let #(x, y) = tuple
    // filter out duplicates using x <= y
    x <= y && is_triple(x, y)
  })
}
