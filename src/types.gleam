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
pub opaque type Shape {
  Square(side_length: Float)
  Rectangle(length: Float, width: Float)
  Circle(radius: Float)
}

pub fn square(side_length: Float) -> Result(Shape, String) {
  case side_length <. 0.0 {
    True -> Error("Squares cannot have negative side length")
    False -> Ok(Square(side_length))
  }
}

pub fn rectangle(length: Float, width: Float) -> Result(Shape, String) {
  case Nil {
    _ if length <. 0.0 -> Error("Rectangles cannot have negative length")
    _ if width <. 0.0 -> Error("Rectangles cannot have negative width")
    _ -> Ok(Rectangle(length, width))
  }
}

pub fn circle(radius: Float) -> Result(Shape, String) {
  case radius <. 0.0 {
    True -> Error("Circles cannot have negative radius")
    False -> Ok(Circle(radius))
  }
}

pub fn calc_area(shape: Shape) -> Float {
  case shape {
    Square(side_length) -> arithmetic.square(side_length)
    Rectangle(length, width) -> length *. width
    Circle(radius) -> arithmetic.square(radius) *. elementary.pi()
  }
}
