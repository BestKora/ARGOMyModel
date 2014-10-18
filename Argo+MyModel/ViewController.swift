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

class ViewController: UITableViewController {
    var places :[Place]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    // MARK: - Take data from Flickr
    
    func getData() {
        let urlPlaces = FlickrFetcher.URLforTopPlaces()
        Get.jsonRequest(urlPlaces) {json in
            //----   С использованием дополнительных pipe операторов извлечения словаря и массива -----
            let pl = json >>- JSONValue.parse >>- Places1.decoder
            self.places = pl?.places
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
                println("PLACES \(pl)")
                
            }
        }
    }
    
    // MARK: - TableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier = "PlaceCell"
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        cell.textLabel!.text = self.places![indexPath.row].content
        cell.detailTextLabel!.text = "\(self.places![indexPath.row].photoCount)"
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places?.count ?? 0
    }
}

