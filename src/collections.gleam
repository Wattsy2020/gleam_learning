import gleam/list
import gleam/option.{type Option, None, Some}

const nums = [1, 2, 3, 4]

pub fn count(list: List(a), predicate: fn(a) -> Bool) -> Int {
  list
  |> list.fold(0, fn(num_items, item) {
    num_items
    + case predicate(item) {
      True -> 1
      False -> 0
    }
  })
}

pub fn listresult() -> Int {
  nums
  |> count(fn(x) { x > 2 })
}

pub fn tuples() -> #(String, Int) {
  [#("This", 0), #("is", 1), #("a", 2), #("tuple", 3)]
  |> list.fold(#("", 0), fn(acc_tuple, tuple) {
    let #(acc_string, acc_sum) = acc_tuple
    let #(string, num) = tuple
    #(acc_string <> " " <> string, acc_sum + num)
  })
}

pub fn first_satisfying(list: List(a), predicate: fn(a) -> Bool) -> Option(a) {
  case list {
    [] -> None
    [first, ..remaining] ->
      case predicate(first) {
        True -> Some(first)
        False -> first_satisfying(remaining, predicate)
      }
  }
}
