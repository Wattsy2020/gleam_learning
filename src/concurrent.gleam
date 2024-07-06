import gleam/list
import gleam/otp/task

// note: after creating tasks they all start running
// so we can wait forever on one while the others are running
pub fn await_all_forever(tasks: List(task.Task(a))) -> List(a) {
  list.map(tasks, task.await_forever)
}
