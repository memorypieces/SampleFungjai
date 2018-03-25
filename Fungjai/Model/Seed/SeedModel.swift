//
//  SeedModel.swift
//  Fungjai
//
//  Created by BSD_MAC_Pro2 on 25/3/18.
//  Copyright © 2018 BSD_MAC_Pro2. All rights reserved.
//

import Foundation
import ObjectMapper

class Seed: NSObject, Mappable
{
    var id : Int?
    var name : String?
    var type : String?
    var coverUrl : URL?
    
    var isTrack : Bool {
        if let type = type,type.lowercased() ==  "track" {
            return true
        }else{
            return false
        }
    }
    
    var isVideo : Bool {
        if let type = type,type.lowercased() ==  "video" {
            return true
        }else{
            return false
        }
    }
    
    var isAds : Bool {
        if let type = type,type.lowercased() ==  "ads" {
            return true
        }else{
            return false
        }
    }
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        id              <- map["id"]
        name            <- map["name"]
        type            <- map["type"]
        coverUrl        <- (map["cover"], URLTransform(shouldEncodeURLString: false))
    }
}
