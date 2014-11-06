
//
//  Result.swift
//  swiftz
//
//  Created by Maxwell Swadling on 9/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

// Result is similar to an Either, except the Left side is always an NSError.

import Foundation

final class Box<A> {
    let value: A
    
     init(_ value: A) {
        self.value = value
    }
}

 enum Result<A> {
    case Error(NSError)
    case Value(Box<A>)
    
   func flatMap<B>(f:A -> Result<B>) -> Result<B> {
        switch self {
        case .Value(let v): return f(v.value)
        case .Error(let error): return .Error(error)
        }
    }
    
    
  init(_ error: NSError?, _ value: A) {
        if let err = error {
            self = .Error(err)
        } else {
            self = .Value(Box(value))
        }
    }
    var value : A? {
        switch self {
        case .Value(let v): return v.value
        default : return nil
        }
    }
}
// ----------------operators Result<A> ----

func >>-<A, B>(a: Result<A>, f: A -> Result<B>) -> Result<B> {
    switch a {
    case let .Value(x):     return f(x.value)
    case let .Error(error): return .Error(error)
    }
}

//--------------- Для печати Result<A> ---

func stringResult<A: Printable>(result: Result<A> ) -> String {
    switch result {
    case let .Error(err):
        return "\(err.localizedDescription)"
    case let .Value(box):
        return "\(box.value.description)"
    }
}

