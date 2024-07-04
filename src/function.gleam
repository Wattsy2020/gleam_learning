pub fn uncurry(tuple: #(a, b), function: fn(a, b) -> c) -> c {
  let #(item1, item2) = tuple
  function(item1, item2)
}
