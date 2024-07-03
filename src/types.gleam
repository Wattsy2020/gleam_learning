import arithmetic
import gleam_community/maths/elementary

// enum
pub type OS {
  Linux
  Mac
  Windows
}

pub fn path_separator(os: OS) -> String {
  case os {
    Linux | Mac -> "/"
    Windows -> "\\"
  }
}

// discriminated union
pub type Shape {
  Square(side_length: Float)
  Rectangle(length: Float, width: Float)
  Circle(radius: Float)
}

pub fn calc_area(shape: Shape) -> Float {
  case shape {
    Square(side_length) -> arithmetic.square(side_length)
    Rectangle(length, width) -> length *. width
    Circle(radius) -> arithmetic.square(radius) *. elementary.pi()
  }
}
