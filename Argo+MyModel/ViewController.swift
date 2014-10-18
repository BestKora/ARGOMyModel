//
//  ViewController.swift
//  Argo+MyModel
//
//  Created by Tatiana Kornilova on 10/17/14.
//  Copyright (c) 2014 Tatiana Kornilova. All rights reserved.
//

import UIKit

func toURL(urlString: String) -> NSURL {
    return NSURL(string: urlString)
}

class ViewController: UIViewController {
    var places :[Place]?

    override func viewDidLoad() {
        super.viewDidLoad()
//------- comment
        let json: AnyObject? = JSONFileReader.JSON(fromFile: "comment")
        let comment = json >>- JSONValue.parse >>- Comment.decoder
        println("\(comment)")
        
        let json1: AnyObject? = JSONFileReader.JSON(fromFile: "post_comments")
        let post = json1 >>- JSONValue.parse >>- Post.decoder
        println("\(post!)")
        
        getData()

    }
    func getData() {
        let urlPlaces  = toURL( "https://api.flickr.com/services/rest/?method=flickr.places.getTopPlacesList&place_type_id=7&format=json&nojsoncallback=1&api_key=2d57c18bb70d5b3aea7b3b0034567af1")
        Get.jsonRequest(urlPlaces) {json in
            //----   С использованием дополнительных pipe операторов извлечения словаря и массива -----
            let pl = json >>- JSONValue.parse >>- Places.decoder
            dispatch_async(dispatch_get_main_queue()) {
                    println("PLACES \(pl)")
                
            }
            
        }
        
    }


}

