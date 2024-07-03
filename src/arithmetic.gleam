const const_int = 2

pub fn fast_power(base: Int, exponent: Int) -> Int {
  case exponent {
    0 -> 1
    _ ->
      case exponent % 2 == 0 {
        True -> {
          let half_powered = fast_power(base, exponent / 2)
          half_powered * half_powered
        }
        False -> base * fast_power(base, exponent - 1)
      }
  }
}

pub fn square(base: Float) -> Float {
  base *. base
}

pub fn basics() -> Int {
  let immutable_var = const_int
  immutable_var * 2
  |> fast_power(2)
}
