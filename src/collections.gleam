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

pub fn tuples() -> #(String, Int) {
  [#("This", 0), #("is", 1), #("a", 2), #("tuple", 3)]
  |> list.fold(#("", 0), fn(acc_tuple, tuple) {
    let #(acc_string, acc_sum) = acc_tuple
    let #(string, num) = tuple
    #(acc_string <> " " <> string, acc_sum + num)
  })
}

/// Concats without having to reverse the list (like the standard library)
/// However this doesn't have tail call optimisation
/// so it uses lots of memory in stack frames and may cause stack overflow
/// the standard library concat has tail call optimisation to avoid this 
fn do_concat(current_list: List(a), lists: List(List(a))) -> List(a) {
  case current_list, lists {
    [], [] -> []
    [], [first_list, ..remaining_lists] ->
      do_concat(first_list, remaining_lists)
    [first_elem, ..remaining_elems], remaining_lists -> [
      first_elem,
      ..do_concat(remaining_elems, remaining_lists)
    ]
  }
}

pub fn concat(lists: List(List(a))) -> List(a) {
  case lists {
    [] -> []
    [list, ..remaining_lists] -> do_concat(list, remaining_lists)
  }
}
