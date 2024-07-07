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

fn do_from_list(list: List(a)) -> NextFunction(a) {
  fn(_timeout) {
    case list {
      [] -> Ok(Done)
      [first, ..remaining] -> Ok(Output(first, do_from_list(remaining)))
    }
  }
}

pub fn from_list(list: List(a)) -> Iterator(a) {
  Iterator(do_from_list(list))
}

fn do_concat(first: NextFunction(a), second: NextFunction(a)) -> NextFunction(a) {
  fn(timeout) {
    case first(timeout) {
      Ok(Output(result, next_function)) ->
        Ok(Output(result, do_concat(next_function, second)))
      Ok(Done) -> second(timeout)
      Error(error) -> Error(error)
    }
  }
}

pub fn concat(first: Iterator(a), second: Iterator(a)) -> Iterator(a) {
  Iterator(do_concat(first.next, second.next))
}
