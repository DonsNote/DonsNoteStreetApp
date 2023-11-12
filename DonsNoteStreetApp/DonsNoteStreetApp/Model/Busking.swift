//
//  Busking.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 10/28/23.
//

import Foundation
import MapKit

struct Busking : Identifiable, Codable {
    
    var id : Int
    var artistId : Int
    var buskingName : String
    var artistImageURL : String
    var buskingInfo : String
    var startTime : Date
    var endTime : Date
    var latitude : Double
    var longitude : Double
    
    init (
        
        id : Int = 0,
        artistId : Int = 0,
        buskingName : String = "",
        artistImageURL : String = "",
        buskingInfo : String = "",
        startTime : Date = Date(),
        endTime : Date = Date(),
        latitude : Double = 0.0,
        longitude : Double = 0.0
        
    ) {
        
        self.id = id
        self.artistId = artistId
        self.buskingName = buskingName
        self.artistImageURL = artistImageURL
        self.buskingInfo = buskingInfo
        self.startTime = startTime
        self.endTime = endTime
        self.latitude = latitude
        self.longitude = longitude
        
    }
    
    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
