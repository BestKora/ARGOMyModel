//
//  RespondParse.swift
//  EfficientJSON
//
//  Created by Tatiana Kornilova on 10/16/14.
//  Copyright (c) 2014 Tatiana Kornilova. All rights reserved.
//

import Foundation

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

func performRequest<A: JSONDecodable>
                   (request: NSURLRequest, callback: (Result<A>) -> ()) {
                    
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
        data, urlResponse, error in
            callback( parseResult(data, urlResponse, error))
    }
                    
    task.resume()
}

func parseResult<A: JSONDecodable>(data: NSData!,
                                   urlResponse: NSURLResponse!,
                                   error: NSError!) -> Result<A> {
    let responseResult: Result<Response> =
                        Result(error, Response(data: data, urlResponse: urlResponse))
    return responseResult >>- parseResponse
                          >>- decodeJSON
                          >>- decodeObject
}

func parseResponse(response: Response) -> Result<NSData> {
    let successRange = 200..<300
    if !contains(successRange, response.statusCode) {
        return .Error(NSError()) // customize the error message to your liking
    }
    return Result(nil, response.data)
}

func decodeObject<A: JSONDecodable>(json: JSONValue) -> Result<A> {
    return resultFromOptional(A.decoder(json),
        NSError(localizedDescription: "Отсутствуют компоненты Модели"))
}


//------------- JSON -> A? -------------

func decodeObject<A: JSONDecodable>(json: JSONValue) -> A? {
    return json  >>- A.decoder
}

//------------------ Для Optionals JSONValue? -----

func decodeJSON(data: NSData?) -> JSONValue? {
    var jsonErrorOptional: NSError?
    let jsonOptional: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!,
                                               options: NSJSONReadingOptions(0),
                                                      error: &jsonErrorOptional)
    if let json: JSONValue = jsonOptional  >>- JSONValue.parse{
        return json
    } else {
        return .None
    }
}

//------------------ Для Result<JSON> -----

func decodeJSON(data: NSData) -> Result<JSONValue> {
    var jsonErrorOptional: NSError?
    let jsonOptional: AnyObject? = NSJSONSerialization.JSONObjectWithData(data,
                                              options: NSJSONReadingOptions(0),
                                                    error: &jsonErrorOptional)
    if let err = jsonErrorOptional {
        return resultFromOptional(jsonOptional  >>- JSONValue.parse,
            NSError (localizedDescription: err.localizedDescription ))
    } else {
        
        return resultFromOptional(jsonOptional  >>- JSONValue.parse, NSError ())
    }
}
//------------------ Преобразование Optionals в Result -----

func resultFromOptional<A>(optional: A?, error: NSError) -> Result<A> {
    if let a = optional {
        return .Value(Box(a))
    } else {
        return .Error(error)
    }
}

//---- Для упрощения работы с классом NSError создаем "удобный" инициализатор в расширении класса

extension NSError {
    convenience init(localizedDescription: String) {
        self.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: localizedDescription])
    }
}

