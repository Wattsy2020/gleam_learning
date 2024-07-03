import extended_should
import gleam/option
import gleeunit/should
import types

pub fn path_separator_linux_test() {
  types.Linux
  |> types.path_separator
  |> should.equal("/")
}

pub fn path_separator_mac_test() {
  types.Mac
  |> types.path_separator
  |> should.equal("/")
}

pub fn path_separator_windows_test() {
  types.Windows
  |> types.path_separator
  |> should.equal("\\")
}

pub fn calc_area_square_test() {
  types.square(2.0)
  |> should.be_ok
  |> types.calc_area
  |> should.equal(4.0)
}

pub fn calc_area_rectangle_test() {
  types.rectangle(2.0, 3.0)
  |> should.be_ok
  |> types.calc_area
  |> should.equal(6.0)
}

pub fn calc_area_circle_test() {
  types.circle(2.0)
  |> should.be_ok
  |> types.calc_area
  |> extended_should.approx_be(12.566, option.Some(0.001))
}
