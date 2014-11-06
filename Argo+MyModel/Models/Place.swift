//
//  Place.swift
//  EfficientJSON
//
//  Created by Tatiana Kornilova on 10/15/14.
//  Copyright (c) 2014 Tatiana Kornilova. All rights reserved.
//

import Foundation


struct Place: Printable,JSONDecodable {
    let placeURL: String
    let timeZone: String
    let photoCount : Int
    let content : String
    
    
    var description : String {
        return "Place { placeURL = \(placeURL), timeZone = \(timeZone), photoCount = \(photoCount),content = \(content)} \n"
    }
    
    static func create(placeURL: String)(timeZone: String)(photoCount: String)(content: String) -> Place {
        return Place(placeURL: placeURL, timeZone: timeZone, photoCount: photoCount.toInt() ?? 0,content: content)
    }
    static var decoder: JSONValue -> Place? {
    return Place.create
        <^> <|"place_url"
        <*> <|"timezone"
        <*> <|"photo_count"
        <*> <|"_content"
    }
}
// ---- Конец структуры Place ----


// ----Структура Places со stat----

struct Places: Printable,JSONDecodable {
    let stat:String
    let places : [Place]
    
    var description :String  { get {
        var str: String = "\(stat) "
        for place in self.places {
            str = str +  "\(place) \n"
        }
        return str
        }
    }
    
    static func create(stat:String)(places: [Place]) -> Places {
        return Places(stat:stat, places: places)
    }
    
    static var decoder: JSONValue -> Places? {
    return Places.create
        <^> <|"stat"
        <*> <||["places", "place"]
    }

}
// ----Структура Places только [Place]----

struct Places1: Printable,JSONDecodable {

    let places : [Place]
    
    var description :String  { get {
        var str: String = ""
        for place in self.places {
            str = str +  "\(place) \n"
        }
        return str
        }
    }
    
    static func create(places: [Place]) -> Places1 {
        return Places1( places: places)
    }
    
    static var decoder: JSONValue -> Places1? {
    return Places1.create
        <^> <||["places", "place"]
    }
}

