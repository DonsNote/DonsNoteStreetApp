//
//  Artist.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 10/28/23.
//

import Foundation

struct Artist : Codable {
    
    var id : Int?
    var artistName : String?
    var artistInfo : String?
    var artistImage : String?
    
    var genres : String?
    var youtubeURL : String?
    var instagramURL : String?
    var soundcloudURL : String?
    
    var members : [Member]?
    var buskings : [Busking]?
    
    init(
        
        id : Int = 0,
        artistName : String = "",
        artistInfo : String = "",
        artistImage : String = "",
        
        genres : String = "",
        youtubeURL : String = "",
        instagramURL : String = "",
        soundcloudURL : String = "",
        
        members : [Member] = [],
        buskings : [Busking] = []
        
    ) {
        
        self.id = id
        self.artistName = artistName
        self.artistInfo = artistInfo
        self.artistImage = artistImage
        
        self.genres = genres
        self.youtubeURL = youtubeURL
        self.instagramURL = instagramURL
        self.soundcloudURL = soundcloudURL
        
        self.members = members
        self.buskings = buskings
    }
}
