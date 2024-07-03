import arithmetic
import extended_should
import gleam/float
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

// this should really be a property based test
pub fn is_near_integer_true_test() {
  [-0.0, 0.0, -5.0, 5.0, 1_000_000.000000001]
  |> extended_should.all_satisfy(arithmetic.is_near_integer, float.to_string)
}

pub fn is_near_integer_false_test() {
  [-0.0001, 0.0001, -0.5, 0.5, 0.9, 0.99, 0.999, 0.9999, 2.001, 4.001]
  |> extended_should.all_satisfy(
    fn(num) { !arithmetic.is_near_integer(num) },
    float.to_string,
  )
}
