import collections
import gleam/float
import gleam/option.{type Option, None, Some}
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

pub fn all_satisfy(
  results: List(a),
  predicate: fn(a) -> Bool,
  to_string: fn(a) -> String,
) -> Nil {
  case
    collections.first_satisfying(results, fn(result) { !predicate(result) })
  {
    None -> Nil
    Some(unmatching) ->
      panic as {
        "Value: " <> to_string(unmatching) <> " did not satisfy the predicate"
      }
  }
}
