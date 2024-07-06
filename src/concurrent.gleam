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
pub fn iterate_results(callbacks: List(fn() -> a)) -> iterator.Iterator(a) {
  let all_results_subject = process.new_subject()
  list.each(callbacks, fn(callback) {
    process.start(fn() { process.send(all_results_subject, callback()) }, False)
  })

  // forgive me, for I have created a mutable variable using a subject
  //let num_results_subject = process.new_subject()
  //process.send(num_results_subject, 0)

  iterator.Iterator(next: fn(timeout) {
    case
      process.receive(
        all_results_subject,
        duration.blur_to(timeout, duration.MilliSecond),
      )
    {
      Ok(result) -> {
        //let assert Ok(num_results_processed) =
        //  process.receive(num_results_subject, 1)
        //process.send(num_results_subject, num_results_processed + 1)
        Ok(result)
      }
      Error(_) -> Error(iterator.Timeout)
    }
  })
}
