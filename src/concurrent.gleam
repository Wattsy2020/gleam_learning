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

fn make_next_result_function(
  subject: process.Subject(a),
  num_processed: Int,
  num_expected_results: Int,
) -> iterator.NextFunction(a) {
  fn(timeout) {
    case num_processed == num_expected_results {
      True -> Ok(iterator.Done)
      False ->
        case
          process.receive(
            subject,
            duration.blur_to(timeout, duration.MilliSecond),
          )
        {
          Ok(result) ->
            Ok(iterator.Output(
              result,
              make_next_result_function(
                subject,
                num_processed + 1,
                num_expected_results,
              ),
            ))
          Error(_) -> Error(iterator.Timeout)
        }
    }
  }
}

/// Start the callbacks as processes and return an iterator over their results
pub fn iterate_results(callbacks: List(fn() -> a)) -> iterator.Iterator(a) {
  let all_results_subject = process.new_subject()
  list.each(callbacks, fn(callback) {
    process.start(fn() { process.send(all_results_subject, callback()) }, False)
  })

  let num_expected_results = list.length(callbacks)
  iterator.Iterator(make_next_result_function(
    all_results_subject,
    0,
    num_expected_results,
  ))
}
