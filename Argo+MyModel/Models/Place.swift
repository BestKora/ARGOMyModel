//
//  Place.swift
//  EfficientJSON
//
//  Created by Tatiana Kornilova on 10/15/14.
//  Copyright (c) 2014 Tatiana Kornilova. All rights reserved.
//

import Foundation
func dictionary(input: JSONValue)(key :String)  ->  JSONValue? {
    switch input {
    case let .JSONObject(d):
        return d [key]
    default:
        return nil
    }
}
func array(input: JSONValue) ->  [JSONValue]? {
    switch input {
    case let .JSONArray(arr):
        return arr
    default:
        return nil
    }
}
struct Place: Printable,JSONDecodable {
    let placeURL: String
    let timeZone: String
    let photoCount : String
    let content : String
    
    
    var description : String {
        return "Place { placeURL = \(placeURL), timeZone = \(timeZone), photoCount = \(photoCount),content = \(content)} \n"
    }
    
    static func create(placeURL: String)(timeZone: String)(photoCount: String)(content: String) -> Place {
        return Place(placeURL: placeURL, timeZone: timeZone, photoCount: photoCount,content: content)
    }
    
    static func stringResult(result: Result<Place> ) -> String {
        switch result {
        case let .Error(err):
            return "\(err.localizedDescription)"
        case let .Value(box):
            return "\(box.value.description)"
        }
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


// ----Структура Places ----

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

    static func stringResult(result: Result<Places> ) -> String {
        switch result {
        case let .Error(err):
            return "\(err.localizedDescription)"
        case let .Value(box):
            return "\(box.value.description)"
        }
    }
}
