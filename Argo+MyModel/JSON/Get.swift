//
//  Get.swift
//  Argo+MyModel
//
//  Created by Tatiana Kornilova on 10/17/14.
//  Copyright (c) 2014 Tatiana Kornilova. All rights reserved.
//

//
//  Get.swift
//  CrisEidnof
//
//  Created by Tatiana Kornilova on 10/7/14.
//  Copyright (c) 2014 Tatiana Kornilova. All rights reserved.
//

import Foundation

class Get {
    class func jsonRequest(url: NSURL, callback: (AnyObject? ) -> ()) {
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { data, urlResponse, error in
            callback(self.parseData(data,  urlResponse: urlResponse, error: error))
        }
        task.resume()
    }
    
    class func parseData(data: NSData!, urlResponse: NSURLResponse!, error: NSError!) -> AnyObject?  {
        if let err = error {
            return nil
        }
        let responseResult: Response = Response(data: data, urlResponse: urlResponse)
        return   self.parseResponse (responseResult) >>- self.decodeJSON
    }
    
    class func parseResponse(response: Response) -> NSData? {
        let successRange = 200..<300
        if !contains(successRange, response.statusCode) {
            return nil
        }
        return response.data
    }
    struct Response {
        let data: NSData
        let statusCode: Int = 500
        
        init(data: NSData, urlResponse: NSURLResponse) {
            self.data = data
            if let httpResponse = urlResponse as? NSHTTPURLResponse {
                statusCode = httpResponse.statusCode
            }
        }
    }
    
    class func decodeJSON(data: NSData) -> AnyObject? {
        var errorOptional: NSError?
        let jsonOptional: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &errorOptional)
        
        switch (errorOptional){
        case let (.Some (err)): return nil
        default: break
        }
        
        switch (jsonOptional){
        case let(.Some (json)): return json
        default: return nil
        }
    }
    
}