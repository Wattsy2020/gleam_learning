import gleam/float
import gleam/list
import gleam/option.{type Option}
import gleam/string
import gleam_community/maths/piecewise

const default_epsilon = 0.000_000_001

pub fn approx_be(actual: Float, expected: Float, epsilon: Option(Float)) -> Nil {
  let difference = piecewise.float_absolute_difference(actual, expected)
  case difference <. option.unwrap(epsilon, default_epsilon) {
    True -> Nil
    False ->
      panic as {
        "Actual: "
        <> float.to_string(actual)
        <> " does not equal the expected: "
        <> float.to_string(expected)
      }
  }
}

pub fn all_satisfy(results: List(a), predicate: fn(a) -> Bool) -> Nil {
  case list.find(results, fn(result) { !predicate(result) }) {
    Error(_) -> Nil
    Ok(unmatching) ->
      panic as {
        "Value: " <> string.inspect(unmatching) <> " violated the predicate"
      }
  }
}
