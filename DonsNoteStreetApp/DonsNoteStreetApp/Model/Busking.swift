//
//  Busking.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 10/28/23.
//

import Foundation

struct Busking : Codable {
    
    var id : Int
    var buskingInfo : String
    var startTime : Date
    var endTime : Date
    var latitude : Double
    var longitude : Double
    
    init (
        
        id : Int = 0,
        buskingInfo : String = "",
        startTime : Date = Date(),
        endTime : Date = Date(),
        latitude : Double = 0.0,
        longitude : Double = 0.0
        
    ) {
        
        self.id = id
        self.buskingInfo = buskingInfo
        self.startTime = startTime
        self.endTime = endTime
        self.latitude = latitude
        self.longitude = longitude
        
    }
}
