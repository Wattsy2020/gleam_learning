import birl/duration
import gleam/list
import iterator
import qcheck/generator
import qcheck/qtest

pub fn from_list_test() {
  use list <- qtest.given(generator.list_generic(
    generator.int_uniform(),
    0,
    100,
  ))

  let assert Ok(converted_list) = {
    list
    |> iterator.from_list
    |> iterator.to_list(duration.milli_seconds(0))
  }
  converted_list == list
}

pub fn map_test() {
  use list <- qtest.given(generator.list_generic(
    generator.int_uniform(),
    0,
    100,
  ))

  let map_func = fn(item) { item * 2 }
  let assert Ok(mapped_list) = {
    list
    |> iterator.from_list
    |> iterator.map(map_func)
    |> iterator.to_list(duration.milli_seconds(0))
  }
  mapped_list == list.map(list, map_func)
}

pub fn concat_test() {
  let list_generator = generator.list_generic(generator.int_uniform(), 0, 100)
  use #(list1, list2) <- qtest.given(generator.tuple2(
    list_generator,
    list_generator,
  ))

  let assert Ok(concatenated_list) = {
    iterator.concat(iterator.from_list(list1), iterator.from_list(list2))
    |> iterator.to_list(duration.milli_seconds(0))
  }
  list.concat([list1, list2]) == concatenated_list
}

pub fn flatten_test() {
  use lists <- qtest.given(generator.list_generic(
    generator.list_generic(generator.int_uniform(), 0, 100),
    0,
    10,
  ))

  let assert Ok(flattened_list) = {
    lists
    |> iterator.from_list
    |> iterator.flatten
    |> iterator.to_list(duration.milli_seconds(0))
  }
  list.flatten(lists) == flattened_list
}
