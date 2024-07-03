import collections
import gleam/string
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  1
  |> should.equal(1)
}

pub fn count_intlist_test() {
  [1, 2, 6, 5, -5, 0]
  |> collections.count(fn(num) { num > 2 })
  |> should.equal(2)
}

pub fn count_stringlen_test() {
  ["hello", "there", "general", "kenobi", "!"]
  |> collections.count(fn(str) { str |> string.length == 5 })
  |> should.equal(2)
}
