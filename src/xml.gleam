import gleam/string

pub type XmlNode {
  Element(name: String, inner_node: XmlNode)
  Value(value: String)
}

pub fn parse_xml(xml: String) -> Result(XmlNode, Nil) {
  case xml {
    "" -> Ok(Value(""))
    _ ->
      case string.split_once(xml, "<") {
        // there is no opening tag, treat this as a value
        Error(Nil) -> Ok(Value(xml))
        // ensure there was nothing before the opening tag
        Ok(#("", remaining_xml)) ->
          case string.split_once(remaining_xml, ">") {
            // opening tag not matched by closing tag, xml is invalid
            Error(Nil) -> Error(Nil)
            // search for closing tag
            Ok(#(tag_name, remaining_xml2)) ->
              case string.split_once(remaining_xml2, "</") {
                // no closing tag, xml is invalid
                Error(Nil) -> Error(Nil)
                // search for the name of the closing tag
                Ok(#(value, remaining_xml3)) ->
                  case string.split_once(remaining_xml3, ">") {
                    // closing tag is not closed, xml is invalid
                    Error(Nil) -> Error(Nil)
                    Ok(#(closing_tag_name, remaining_xml4)) ->
                      case tag_name == closing_tag_name {
                        // the tag pair doesn't match up
                        False -> Error(Nil)
                        // finally got a valid result
                        True -> Ok(Element(tag_name, Value(value)))
                      }
                  }
              }
          }
        // we handle a value between xml tags above, if we get here it means there's invalid xml
        // like "invalid<tag>value2</tag", where "invalid" should be enclosed in a tag
        _ -> Error(Nil)
      }
  }
}
