import gleam/int
import gleam/io
import learning

pub fn main() {
  io.println("Hello from pythagorean_triplets!")
  io.println(learning.basics() |> int.to_string)
}
