//
//  Location.swift
//  Walking and Talking
//
//  Created by Kieran Waugh on 30/11/2019.
//  Copyright © 2019 Kieran Waugh. All rights reserved.
//

import Foundation

class Place : Codable {
    
    let uuid : String?
    let name : String?
    let latitude : Double?
    let longtude : Double?
    let open : Bool?
    let category : String?
    
    init(uuid:String, name: String, latitude:Double, longitude:Double, open:Bool, category: String){
        self.uuid = uuid
        self.name = name
        self.latitude = latitude
        self.longtude = longitude
        self.open = open
        self.category = category
    }

}
