import birl/duration
import gleam/result

pub type IteratorError {
  Timeout
  Other(details: String)
}

pub type NextFunction(a) =
  fn(duration.Duration) -> Result(IteratorOutput(a), IteratorError)

pub type IteratorOutput(a) {
  Output(output: a, next: NextFunction(a))
  Done
}

pub type Iterator(a) {
  Iterator(next: NextFunction(a))
}

fn do_map(next: NextFunction(a), function: fn(a) -> b) -> NextFunction(b) {
  fn(timeout) {
    use iterator_output <- result.map(next(timeout))
    case iterator_output {
      Output(output, next_function) ->
        Output(function(output), do_map(next_function, function))
      Done -> Done
    }
  }
}

// an fmap to make Iterator a functor
pub fn map(iterator: Iterator(a), function: fn(a) -> b) -> Iterator(b) {
  Iterator(do_map(iterator.next, function))
}

fn do_to_list(
  next: NextFunction(a),
  timeout: duration.Duration,
) -> Result(List(a), IteratorError) {
  case next(timeout) {
    Ok(Output(output, next_function)) -> {
      use remaining_elems <- result.map(do_to_list(next_function, timeout))
      [output, ..remaining_elems]
    }
    Ok(Done) -> Ok([])
    Error(error) -> Error(error)
  }
}

pub fn to_list(
  iterator: Iterator(a),
  timeout: duration.Duration,
) -> Result(List(a), IteratorError) {
  do_to_list(iterator.next, timeout)
}
