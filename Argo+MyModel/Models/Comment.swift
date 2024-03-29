struct Comment:Printable {
  let id: Int
  let text: String
  let authorName: String
    var description : String {
        return "Comment: { id = \(id), text = \(text), authorName = \(authorName)} \n"
    }

}


extension Comment: JSONDecodable {
  static func create(id: Int)(text: String)(authorName: String) -> Comment {
    return Comment(id: id, text: text, authorName: authorName)
  }

  static var decoder: JSONValue -> Comment? {
    return Comment.create
      <^> <|"id"
      <*> <|"text"
      <*> <|["author", "name"]
  }
}
