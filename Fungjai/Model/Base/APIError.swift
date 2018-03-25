//
//  APIError.swift
//  AALib
//
//  Created by BSD_MAC_Pro2 on 15/1/18.
//  Copyright © 2018 BSD_MAC_Pro2. All rights reserved.
//

import Foundation

class APIError {
    typealias ErrorType = (code:Int, message:String)
    
    static let domain = "TSErrorDomain"
    
    struct type {
        static let unknown = NSError(domain: APIError.domain, code: -2, userInfo: ["error_message": "unknown error"])
        static let emptyResponse = NSError(domain: APIError.domain, code: 0, userInfo: ["error_message": "empty response"])
        static let emptyData = NSError(domain: APIError.domain, code: 1, userInfo: ["error_message": "empty data"])
        static let invalidFormat = NSError(domain: APIError.domain, code: 2, userInfo: ["error_message": "invalid format response"])
        static let failed = NSError(domain: APIError.domain, code: 3, userInfo: ["error_message": "Observation failed"])
    }
}
