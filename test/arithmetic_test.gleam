import arithmetic
import gleam/list
import gleeunit/should

pub fn fast_power_zero_test() {
  [-1, 0, 1, 2, 1000]
  |> list.map(arithmetic.fast_power(_, 0))
  |> list.all(fn(num) { num == 1 })
  |> should.be_true
}

pub fn fast_power_one_test() {
  [-1, 0, 1, 2, 1000]
  |> list.all(fn(num) { arithmetic.fast_power(num, 1) == num })
  |> should.be_true
}

pub fn fast_power_four_test() {
  [#(-1, 1), #(0, 0), #(1, 1), #(2, 16), #(1000, 1_000_000_000_000)]
  |> list.all(fn(num_tuple) {
    let #(input, expected) = num_tuple
    arithmetic.fast_power(input, 4) == expected
  })
  |> should.be_true
}
