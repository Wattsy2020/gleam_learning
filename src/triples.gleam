import arithmetic
import concurrent
import function
import gleam/int
import gleam/list
import gleam/otp/task

fn is_triple(x: Int, y: Int) -> Bool {
  let sum_squares = arithmetic.square_int(x) + arithmetic.square_int(y)
  case int.square_root(sum_squares) {
    Ok(square_root) -> arithmetic.is_near_integer(square_root)
    Error(_) -> False
  }
}

fn calc_triples_for(first_num: Int, up_to: Int) -> List(#(Int, Int)) {
  // note that for it to be a triple: a^2 + b^2 >= (b+1)^2 must hold
  // so that a^2 can add with b^2 to equal at least one other square (the closest is b+1^2)
  // simplifying the expression shows the max number to consider is (a^2 -1)/2
  list.range(
    first_num,
    int.min(up_to, int.max({ arithmetic.square_int(first_num) - 1 } / 2, 1)),
  )
  |> list.map(fn(second_num) { #(first_num, second_num) })
  // filter potential triples
  |> list.filter(function.uncurry(_, is_triple))
}

/// Calculates all pythagorean triples (x, y) where x <= n and y <= n
pub fn calc_triples(n: Int) -> List(#(Int, Int)) {
  list.range(1, n)
  |> list.map(calc_triples_for(_, n))
  |> list.flatten
}

pub fn calc_triples_parallel(n: Int) -> List(#(Int, Int)) {
  list.range(1, n)
  |> list.map(fn(first_num) {
    task.async(fn() { calc_triples_for(first_num, n) })
  })
  |> concurrent.await_all_forever
  |> list.flatten
}
