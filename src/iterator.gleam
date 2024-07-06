import birl/duration
import gleam/result

pub type IteratorError {
  Timeout
  Other(details: String)
}

pub type IteratorOutput(input, output) {
  Output(output: output, next_input: input)
  Done
}

pub type Iterator(input, output) {
  Iterator(
    initial_input: input,
    next: fn(input, duration.Duration) ->
      Result(IteratorOutput(input, output), IteratorError),
  )
}

// an fmap to make Iterator a functor
pub fn map(
  iterator: Iterator(input, output),
  function: fn(output) -> new_output,
) -> Iterator(input, new_output) {
  Iterator(iterator.initial_input, next: fn(input, timeout) {
    use iterator_output <- result.map(iterator.next(input, timeout))
    case iterator_output {
      Output(output, input) -> Output(function(output), input)
      Done -> Done
    }
  })
}

fn do_to_list(
  iterator_input: input,
  iterator: Iterator(input, output),
  timeout: duration.Duration,
) -> Result(List(output), IteratorError) {
  case iterator.next(iterator_input, timeout) {
    Ok(Output(output, next_input)) -> {
      use remaining_elems <- result.map(do_to_list(
        next_input,
        iterator,
        timeout,
      ))
      [output, ..remaining_elems]
    }
    Ok(Done) -> Ok([])
    Error(error) -> Error(error)
  }
}

pub fn to_list(
  iterator: Iterator(input, output),
  timeout: duration.Duration,
) -> Result(List(output), IteratorError) {
  do_to_list(iterator.initial_input, iterator, timeout)
}
