struct Post:Printable {
  let id: Int
  let text: String
  let author: User
  let comments: [Comment]
    
    var description :String  { get {
        var str: String = ""
        for comment in self.comments {
            str = str +  "\(comment) \n"
        }
        return "Post { id = \(id), text = \(text), author = \(author)} \n" + str
        }
    }

}


extension Post: JSONDecodable {
  static func create(id: Int)(text: String)(author: User)(comments: [Comment]) -> Post {
    return Post(id: id, text: text, author: author, comments: comments)
  }

  static var decoder: JSONValue -> Post? {
    return Post.create
      <^> <|"id"
      <*> <|"text"
      <*> <|"author"
      <*> <||"comments"
  }
}

