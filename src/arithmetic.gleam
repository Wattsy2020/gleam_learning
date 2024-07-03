import gleam/int

const const_int = 2

/// Evaluate base to the power of a >= 0 exponent
fn fast_power_positive(base: Int, exponent: Int) -> Int {
  case exponent {
    0 -> 1
    _ ->
      case exponent % 2 == 0 {
        True -> {
          let half_powered = fast_power_positive(base, exponent / 2)
          half_powered * half_powered
        }
        False -> base * fast_power_positive(base, exponent - 1)
      }
  }
}

/// Evaluate an integer to the power of an integer exponent
pub fn fast_power(base: Int, exponent: Int) -> Float {
  case exponent < 0 {
    True -> 1.0 /. int.to_float(fast_power_positive(base, -exponent))
    False -> int.to_float(fast_power_positive(base, exponent))
  }
}

pub fn square(base: Float) -> Float {
  base *. base
}

pub fn basics() -> Float {
  let immutable_var = const_int
  immutable_var * 2
  |> fast_power(2)
}
