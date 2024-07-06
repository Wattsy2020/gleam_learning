import birl/duration
import gleam/erlang/process
import gleam/list
import gleam/otp/task
import iterator

// note: after creating tasks they all start running
// so we can wait forever on one while the others are running
pub fn await_all_forever(tasks: List(task.Task(a))) -> List(a) {
  list.map(tasks, task.await_forever)
}

/// Start the callbacks as processes and return an iterator over their results
pub fn iterate_results(callbacks: List(fn() -> a)) -> iterator.Iterator(Int, a) {
  let all_results_subject = process.new_subject()
  list.each(callbacks, fn(callback) {
    process.start(fn() { process.send(all_results_subject, callback()) }, False)
  })

  let num_expected_results = list.length(callbacks)
  iterator.Iterator(initial_input: 0, next: fn(num_processed, timeout) {
    case
      process.receive(
        all_results_subject,
        duration.blur_to(timeout, duration.MilliSecond),
      )
    {
      Ok(result) -> Ok(iterator.Output(result, num_processed + 1))
      Error(_) ->
        case num_processed == num_expected_results {
          True -> Ok(iterator.Done)
          False -> Error(iterator.Timeout)
        }
    }
  })
}
