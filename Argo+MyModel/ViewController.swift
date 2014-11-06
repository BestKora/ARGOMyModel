//
//  ViewController.swift
//  Argo+MyModel
//
//  Created by Tatiana Kornilova on 10/17/14.
//  Copyright (c) 2014 Tatiana Kornilova. All rights reserved.
//

import UIKit

func toURL(urlString: String) -> NSURL {
    return NSURL(string: urlString)!
}

class ViewController: UITableViewController {
    var places :[Place]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - Take data from Flickr

        let urlPlaces = NSURLRequest( URL: FlickrFetcher.URLforTopPlaces())
        performRequest(urlPlaces) { (places: Result<Places1>) in
            
            switch places {
            case let .Error(err):
                println ("\(err.localizedDescription)")
            case let .Value(pls):
                self.places = pls.value.places
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                       self.testUserAndBlogs()
//                    println("PLACES \(pls.value)")
                }
            }
        }
    }

    
   // MARK: - TableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier = "PlaceCell"
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        cell.textLabel.text = self.places?[indexPath.row].content
        let photoCount = self.places?[indexPath.row].photoCount ?? 0
        cell.detailTextLabel!.text = "\(photoCount)"
        return cell
    }
    
// MARK: - testUserAndBlogs()
    
    func testUserAndBlogs() {
        //---------------- User--------
        let jsonString1: String = "{ \"id\": 1, \"name\":\"Cool user\",  \"email\": \"u.cool@example.com\" }"
        let jsonString: String = "{ \"id\": 1, \"name\":\"Cool user\" }"
        
        let jsonData: NSData? = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions(0), error: nil)
        
        
        let user = json >>- JSONValue.parse >>- User.decoder
        println("USER \(user)")
        //--------------- Post ------
        
        let jsonString5: String = "{\"id\": 3, \"text\": \"A Cool story.\",\"author\": {\"id\": 1,\"name\": \"Cool User\"},\"comments\": [{\"id\": 6,\"text\": \"Cool story bro.\",\"author\": {\"id\": 1,\"name\": \"Cool User\"}},{\"id\": 6,\"text\": \"Cool story bro.\",\"author\": {\"id\": 1,\"name\": \"Cool User\"}}]}"
        let jsonData5: NSData? = jsonString5.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let json5: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData5!, options: NSJSONReadingOptions(0), error: nil)
        
        let post = json5 >>- JSONValue.parse >>- Post.decoder
        println("POST \(post)")
        
        //---------------- Blogs--------
        
        var jsonString3 = "{ \"stat\": \"ok\", \"blogs\": { \"blog\": [ { \"id\" : 73, \"name\" : \"Bloxus test\", \"needspassword\" : true, \"url\" : \"http://remote.bloxus.com/\" }, { \"id\" : 74, \"name\" : \"Manila Test\", \"needspassword\" : false, \"url\" : \"http://flickrtest1.userland.com/\" } ] } }"
        let jsonData3 = jsonString3.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let json3: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData3!, options: NSJSONReadingOptions(0), error: nil)
        
        let blogs = json3 >>- JSONValue.parse >>- Blogs.decoder
        println("Blogs \(blogs)")
        //--------------------------------------
        
    }
   
}
