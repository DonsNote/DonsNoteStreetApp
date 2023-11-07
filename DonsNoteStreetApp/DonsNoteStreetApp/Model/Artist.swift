//
//  Artist.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 10/28/23.
//

import Foundation

struct Artist : Codable {
    
    var id : Int
    var artistName : String
    var artistInfo : String
    var artistImageURL : String
    
    var genres : String?
    var youtubeURL : String?
    var instagramURL : String?
    var soundcloudURL : String?
    
    var follower : [Int]?
    var members : [Int]?
    var buskings : [Int]?
    
    init(
        
        id : Int = 0,
        artistName : String = "",
        artistInfo : String = "",
        artistImageURL : String = "",
        
        genres : String = "",
        youtubeURL : String = "",
        instagramURL : String = "",
        soundcloudURL : String = "",
        
        follower : [Int] = [],
        members : [Int] = [],
        buskings : [Int] = []
        
    ) {
        
        self.id = id
        self.artistName = artistName
        self.artistInfo = artistInfo
        self.artistImageURL = artistImageURL
        
        self.genres = genres
        self.youtubeURL = youtubeURL
        self.instagramURL = instagramURL
        self.soundcloudURL = soundcloudURL
        
        self.follower = follower
        self.members = members
        self.buskings = buskings
    }
}
