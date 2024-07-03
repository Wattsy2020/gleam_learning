import gleam/int

const const_int = 2

// todo: figure out how to loop to evaluate the power
fn power(a: Int, b: Int) -> Int {
  a * b
}

// todo: figure out how to loop to evaluate this properly
fn power_float(a: Float, b: Float) -> Float {
  a *. b
}

pub fn basics() -> Float {
  let immutable_var = const_int
  immutable_var * 2
  |> power(2)
  |> int.to_float
  |> power_float(2.3)
}
