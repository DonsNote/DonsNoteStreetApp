//
//  User.swift
//  DonsNoteStreetApp
//
//  Created by Kimdohyun on 10/28/23.
//

import Foundation

struct User : Codable {
    
    var id : Int
    var artistId : Int?
    var follow : [Int]?
    var block : [Int]?
    var userName : String
    var userInfo : String
    var userImageURL : String
    
    init(
        
        id : Int = 0,
        artistId : Int = 0,
        follow : [Int] = [],
        block : [Int] = [],
        userName : String = "",
        userInfo : String = "",
        userImageURL : String = ""
    
    ) {
        
        self.id = id
        self.artistId = artistId
        self.follow = follow
        self.block = block
        self.userName = userName
        self.userInfo = userInfo
        self.userImageURL = userImageURL
        
    }
}
