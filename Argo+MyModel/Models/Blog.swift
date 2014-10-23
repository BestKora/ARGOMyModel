//
//  Blog.swift
//  Argo+MyModel
//
//  Created by Tatiana Kornilova on 10/23/14.
//  Copyright (c) 2014 Tatiana Kornilova. All rights reserved.
//

import Foundation

struct Blog: Printable,JSONDecodable {
    let id: Int
    let name: String
    let needsPassword : Bool
    let url: NSURL

    
    var description : String { get {
        return "Blog { id = \(id), name = \(name), needsPassword = \(needsPassword), url = \(url)}"
        }}
    
    static func create(id: Int)(name: String)(needsPassword: Int)(url:String) -> Blog {
        return Blog(id: id, name: name,needsPassword: Bool(needsPassword),url: toURL(url))
    }

    static var decoder: JSONValue -> Blog? {
        return Blog.create
            <^> <|"id"
            <*> <|"name"
            <*> <|"needspassword"
            <*> <|"url"
    }
}
// ---- Конец структуры Blog ----


// ----Структура Blogs ----

struct Blogs: Printable,JSONDecodable {
    let stat:String
    let blogs : [Blog]
    
    var description :String  { get {
        var str: String = "\(stat) "
        for blog in self.blogs {
            str = str +  "\(blog) \n"
        }
        return str
        }
    }
    
    static func create(stat:String)(blogs: [Blog]) -> Blogs {
        return Blogs(stat:stat, blogs: blogs)
    }
    
    static var decoder: JSONValue -> Blogs? {
        return Blogs.create
            <^> <|"stat"
            <*> <||["blogs","blog"]

    }
    
}



