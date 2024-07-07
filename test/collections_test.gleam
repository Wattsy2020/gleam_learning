import collections
import gleam/list
import gleam/string
import gleeunit/should
import qcheck/generator
import qcheck/qtest

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

pub fn concat_test() {
  use lists <- qtest.given(generator.list_generic(
    generator.list_generic(generator.int_uniform(), 0, 100),
    0,
    10,
  ))

  list.concat(lists) == collections.concat(lists)
}
