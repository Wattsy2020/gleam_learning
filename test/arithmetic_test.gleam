import arithmetic
import gleam/int
import gleam/list
import gleeunit/should

pub fn fast_power_zero_test() {
  [-1, 0, 1, 2, 1000]
  |> list.map(arithmetic.fast_power(_, 0))
  |> list.all(fn(num) { num == 1.0 })
  |> should.be_true
}

pub fn fast_power_one_test() {
  [-1, 0, 1, 2, 1000]
  |> list.all(fn(num) { arithmetic.fast_power(num, 1) == int.to_float(num) })
  |> should.be_true
}

pub fn fast_power_four_test() {
  [#(-1, 1.0), #(0, 0.0), #(1, 1.0), #(2, 16.0), #(1000, 1_000_000_000_000.0)]
  |> list.all(fn(num_tuple) {
    let #(input, expected) = num_tuple
    arithmetic.fast_power(input, 4) == expected
  })
  |> should.be_true
}

pub fn fast_power_negative_one_test() {
  [-1, 0, 1, 2, 1000]
  |> list.all(fn(num) {
    arithmetic.fast_power(num, -1) == 1.0 /. int.to_float(num)
  })
  |> should.be_true
}

pub fn fast_power_negative_four_test() {
  [
    #(-1, 1.0),
    #(0, 0.0),
    #(1, 1.0),
    #(2, 1.0 /. 16.0),
    #(1000, 1.0 /. 1_000_000_000_000.0),
  ]
  |> list.all(fn(num_tuple) {
    let #(input, expected) = num_tuple
    arithmetic.fast_power(input, -4) == expected
  })
  |> should.be_true
}
