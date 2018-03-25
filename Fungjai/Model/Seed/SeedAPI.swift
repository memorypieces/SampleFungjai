//
//  SeedAPI.swift
//  Fungjai
//
//  Created by BSD_MAC_Pro2 on 25/3/18.
//  Copyright © 2018 BSD_MAC_Pro2. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper

class SeedAPI : API {
    
    override init() {
        super.init()
    }
    static let host = "https://www.anop72.info/api/"
    static let getDataClosure:GetDataClosure = { rawResponse in
        return rawResponse
    }
    
    static let getErrorClosure:GetErrorClosure = { rawResponse in
        return nil
    }
    
    static func getSeeds(callback:@escaping ([Seed]?, Error?)->Void) {
        let headers : HTTPHeaders? = nil
        //http://{{HOST}}/api/v1/Payment/instalment
        let url = "\(host)/seed.json"
        
        _ = request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers,response: { (response) in
            self.performCallback(alamoResult: response.result, getErrorClosure: getErrorClosure, getDataClosure: getDataClosure, callback: callback)
        })
    }
    
    
}
