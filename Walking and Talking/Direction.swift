//
//  direction.swift
//  Walking and Talking
//
//  Created by Kieran Waugh on 28/01/2020.
//  Copyright © 2020 Kieran Waugh. All rights reserved.
//

import Foundation

class Direction : Codable {
    
    let time : String?
    let endLat : String?
    let endLng : String?
    var instruction : String?
    let maneuver : String?
    let startLat : String?
    let startLng  : String?
    let distance : Int?
    
    init(startLat:String, startLng:String, endLat:String, endLng:String, instruction:String, maneuver:String, time:String, distance:Int){
        self.startLat = startLat
        self.startLng = startLng
        self.endLat = endLat
        self.endLng = endLng
        self.instruction = instruction
        self.maneuver = maneuver
        self.time = time
        self.distance = distance
    }
    
    func setInstruction(new: String){
        instruction = new
    }
}
