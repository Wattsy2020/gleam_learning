import birl/duration
import gleam/io
import gleam/result

pub type IteratorError {
  Timeout
  IteratorEnd
  Other(details: String)
}

pub type IteratorReadError {
  ReadTimeout
  ReadOther(details: String)
}

pub type Iterator(a) {
  Iterator(next: fn(duration.Duration) -> Result(a, IteratorError))
}

// an fmap to make Iterator a functor
pub fn map(iterator: Iterator(a), function: fn(a) -> b) -> Iterator(b) {
  Iterator(next: fn(timeout) { result.map(iterator.next(timeout), function) })
}

/// Print the results of the iterator one by one
pub fn log_iterator(iterator: Iterator(a), timeout: duration.Duration) -> Nil {
  case iterator.next(timeout) {
    Ok(first_elem) -> {
      io.debug(first_elem)
      log_iterator(iterator, timeout)
    }
    _ -> Nil
  }
}

pub fn to_list(
  iterator: Iterator(a),
  timeout: duration.Duration,
) -> Result(List(a), IteratorReadError) {
  case iterator.next(timeout) {
    Ok(first_elem) -> {
      use remaining_elems <- result.map(to_list(iterator, timeout))
      [first_elem, ..remaining_elems]
    }
    Error(IteratorEnd) -> Ok([])
    Error(Timeout) -> Error(ReadTimeout)
    Error(Other(details)) -> Error(ReadOther(details))
  }
}
