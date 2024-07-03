import gleam/list

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
