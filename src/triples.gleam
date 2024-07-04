import arithmetic
import function
import gleam/int
import gleam/list

fn is_triple(x: Int, y: Int) -> Bool {
  let sum_squares = arithmetic.square_int(x) + arithmetic.square_int(y)
  case int.square_root(sum_squares) {
    Ok(square_root) -> arithmetic.is_near_integer(square_root)
    Error(_) -> False
  }
}

/// Calculates all pythagorean triples (x, y) where x <= n and y <= n
pub fn calc_triples(n: Int) -> List(#(Int, Int)) {
  // create all potential triples
  list.range(1, n)
  |> list.map(fn(first_num) {
    // note that for it to be a triple: a^2 + b^2 >= (b+1)^2 must hold
    // so that a^2 can add with b^2 to equal at least one other square (the closest is b+1^2)
    // simplifying the expression shows the max number to consider is (a^2 -1)/2
    list.range(
      first_num,
      int.min(n, int.max({ arithmetic.square_int(first_num) - 1 } / 2, 1)),
    )
    |> list.map(fn(second_num) { #(first_num, second_num) })
  })
  |> list.flatten
  // filter potential triples
  |> list.filter(function.uncurry(_, is_triple))
}
